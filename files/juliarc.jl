atreplinit() do REPL
  schedule(@task begin
    sleep(0.1)
    try
      @eval using Revise
    catch
      @warn "Could not load Revise."
    end

#    try
#      @eval using Rebugger
#      # Activate Rebugger's key bindings
#      Rebugger.keybindings[:stepin] = "\e[17~"      # Add the keybinding F6 to step into a function.
#      Rebugger.keybindings[:stacktrace] = "\e[18~"  # Add the keybinding F7 to capture a stacktrace.
#      Rebugger.repl_init(REPL)
#    catch
#      @warn "Could not turn on Rebugger key bindings."
#    end

    try
      @eval using OhMyREPL
    catch
      @warn "Could not load OhMyREPL."
    end
  end)
end
