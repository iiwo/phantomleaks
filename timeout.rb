module PowerScraper
  module Timeout
    include ::Timeout

    # We are redefining timeout for the hack below which is only running thread .join if thread y has not stopped, tbh not totally clear on how or if this is working to solve the original issue with resque instances not dying

    def timeout(sec, klass = nil)   #:yield: +sec+
      return yield(sec) if sec == nil or sec.zero?
      message = "execution expired".freeze
      from = "from #{caller_locations(1, 1)[0]}" if $DEBUG
      e = Error
      bl = proc do |exception|
        begin
          x = Thread.current
          y = Thread.start {
            Thread.current.name = from
            begin
              sleep sec
            rescue => e
              x.raise e
            else
              x.raise exception, message
            end
          }
          return yield(sec)
        ensure
          if y
            y.kill

            # Hack to solve https://github.com/teampoltergeist/poltergeist/issues/747
            unless y.stop?
              y.join(1) # make sure y is dead.
            end
            # END OF HACK

          end
        end
      end
      if klass
        begin
          bl.call(klass)
        rescue klass => e
          bt = e.backtrace
        end
      else
        bt = Timeout::Error.catch(message, &bl)
      end
      level = -caller(CALLER_OFFSET).size-2
      while THIS_FILE =~ bt[level]
        bt.delete_at(level)
      end
      raise(e, message, bt)
    end

    module_function :timeout

  end
end