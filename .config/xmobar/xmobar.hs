Config { font               = "xft:Arimo Nerd Font:pixelsize=12:antialias=true:hinting=true"
       , bgColor            = "#2D2A2E"
       , fgColor            = "#FCFCFA"
       , position           = TopSize L 100 18
       , lowerOnStart       = True
       , pickBroadest       = False
       , persistent         = True
       , allDesktops        = True
       , iconRoot           = "."
       , overrideRedirect   = True
       , commands = [ Run Weather "EGPF" ["--template","<weather> ~ <tempC>°C",
                                          "-L","8","-H","15",
                                          "--normal","green",
                                          "--high","red",
                                          "--low","lightblue"] 36000
                    , Run Network "enp3s0" ["-L","0","-H","320",
                                          "--normal","green",
                                          "--high","red"] 10
                    , Run Cpu ["-L","3","-H","50",
                               "--normal","green","--high","red"] 10
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run Swap [] 10
                    , Run Date "%a %b %_d %Y  ~  %H / %I:%M:%S %P" "date" 10
                    , Run UnsafeStdinReader
                    ]
                    
       , sepChar = "%"
       , alignSep = "}{"
       , template = "  %UnsafeStdinReader% }{ |<fc=#FFD866> 礪 %cpu% </fc>|<fc=#AB9DF2>  %memory% -  %swap% </fc>|<fc=#A9DC76>  %enp3s0% </fc>|<fc=#FC9867>  %date% </fc>|<fc=#78DCE8>  %EGPF% </fc>"
       }


-- <box type=Top width=1 color=#FCFCFA> </box>