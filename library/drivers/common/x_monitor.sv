`include "utils.svh"

package x_monitor_pkg;

  import xil_common_vip_pkg::*;
  import axi4stream_vip_pkg::*;
  import axi_vip_pkg::*;
  import logger_pkg::*;
  import mailbox_pkg::*;

  class x_monitor extends adi_component;

    mailbox_c #(logic [7:0]) mailbox;
    protected semaphore semaphore_key;
    protected event transaction_event;

    protected bit enabled;

    // constructor
    function new(
      input string name,
      input adi_component parent = null);
      
      super.new(name, parent);

      this.mailbox = new("Mailbox", 0, this);
      this.semaphore_key = new(1);
    endfunction

    // semaphore functions
    task get_key();
      this.semaphore_key.get();
    endtask

    task put_key();
      this.semaphore_key.put();
    endtask

    // event functions
    task transaction_captured();
      ->>this.transaction_event;
    endtask

    task wait_for_transaction_event();
      @this.transaction_event;
    endtask

    // run task
    task run();

      fork
        this.enabled = 1;
        get_transaction();
      join_none

    endtask /* run */

    // virtual functions
    virtual function void set_sink_type(input bit sink_type);
    endfunction

    virtual function bit get_sink_type();
    endfunction

    virtual task get_transaction();
    endtask

  endclass

  typedef enum bit {
    READ_OP = 1'b0,
    WRITE_OP = 1'b1
  } operation_type_t;
  
  class x_axi_monitor #( type T, operation_type_t operation_type ) extends x_monitor;
    // operation type: 1 - write
    //                 0 - read

    // analysis port from the monitor
    protected xil_analysis_port #(axi_monitor_transaction) axi_ap;

    protected T agent;

    protected int axi_byte_stream_size;

    // constructor
    function new(
      input string name,
      input T agent,
      input adi_component parent = null);

      super.new(name, parent);

      this.enabled = 0;

      this.agent = agent;
      this.axi_ap = this.agent.monitor.item_collected_port;

      this.axi_byte_stream_size = 0;

    endfunction /* new */

    // collect data from the DDR interface, all WRITE transaction are coming
    // from the ADC and all READ transactions are going to the DAC
    virtual task get_transaction();

      axi_monitor_transaction transaction;
      xil_axi_data_beat data_beat;
      xil_axi_strb_beat strb_beat;
      int num_bytes;
      logic [7:0] axi_byte;

      forever begin
        this.get_key();
        this.axi_ap.get(transaction);
        if (bit'(transaction.get_cmd_type()) == operation_type) begin
          this.put_key();
          num_bytes = transaction.get_data_width()/8;
          for (int i=0; i<(transaction.get_len()+1); i++) begin
            data_beat = transaction.get_data_beat(i);
            strb_beat = transaction.get_strb_beat(i);
            for (int j=0; j<num_bytes; j++) begin
              axi_byte = data_beat[j*8+:8];
              // put each beat into byte queues
              if (operation_type == READ_OP) begin
                this.mailbox.put(axi_byte);
                this.axi_byte_stream_size++;
              end else if (strb_beat[j] || !this.agent.vif_proxy.C_AXI_HAS_WSTRB) begin
                this.mailbox.put(axi_byte);
                this.axi_byte_stream_size++;
              end
            end
            this.info($sformatf("Caught an AXI4 transaction: %d", this.axi_byte_stream_size), ADI_VERBOSITY_MEDIUM);
            this.transaction_captured();
            #1step;
            #1step;
            this.mailbox.flush();
            this.axi_byte_stream_size = 0;
          end
        end else begin
          this.axi_ap.write(transaction);
          this.put_key();
          #1step;
        end
      end

    endtask /* get_transaction */

  endclass


  class x_axis_monitor #( type T) extends x_monitor;

    typedef enum bit { CYCLIC=0, ONESHOT } sink_type_t;
    protected sink_type_t tx_sink_type;

    // analysis port from the monitor
    protected xil_analysis_port #(axi4stream_monitor_transaction) axis_ap;

    protected T agent;

    // constructor
    function new(
      input string name,
      input T agent,
      input adi_component parent = null);

      super.new(name, parent);

      this.enabled = 0;
      this.tx_sink_type = CYCLIC;

      this.agent = agent;
      this.axis_ap = this.agent.monitor.item_collected_port;

    endfunction /* new */

    // set sink type
    virtual function void set_sink_type(input bit sink_type);

      if (!this.enabled) begin
        this.tx_sink_type = sink_type_t'(sink_type);
      end else begin
        this.error($sformatf("ERROR Scoreboard: Can not configure sink_type while scoreboard is running."));
      end

    endfunction

    // get sink type
    virtual function bit get_sink_type();

      return this.tx_sink_type;

    endfunction

    // collect data from the AXI4Strean interface of the stub, this task
    // handles both ONESHOT and CYCLIC scenarios
    virtual task get_transaction();

      axi4stream_transaction transaction;
      xil_axi4stream_data_beat data_beat;
      xil_axi4stream_strb_beat keep_beat;
      int num_bytes;
      logic [7:0] axi_byte;

      forever begin
        this.axis_ap.get(transaction);
        // all bytes from a beat are valid
        num_bytes = transaction.get_data_width()/8;
        data_beat = transaction.get_data_beat();
        keep_beat = transaction.get_keep_beat();
        for (int j=0; j<num_bytes; j++) begin
          axi_byte = data_beat[j*8+:8];
          if (keep_beat[j+:1] || !this.agent.vif_proxy.C_XIL_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_KEEP])
            this.mailbox.put(axi_byte);
        end
        this.info($sformatf("Caught an AXI4 stream transaction: %d", this.mailbox.num()), ADI_VERBOSITY_MEDIUM);
        this.transaction_captured();
        #1step;
        this.mailbox.flush();
      end

    endtask /* get_transaction */

  endclass

endpackage
