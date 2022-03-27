-- SoloJessy's Config

-- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.MouseResize
import XMonad.Actions.WithAll (killAll)

-- Data
import Data.Maybe (fromJust)
import Data.Monoid
import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (docks, avoidStruts, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName

-- Layouts
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns

-- Layout Modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle  (mkToggle, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- Utils
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

-- Theme
import Colors.MonokaiPro

-- VARIABLES
myFont :: String
myFont      = "xft:FiraMono Nerd Font:bold:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask   = mod4Mask

myTerminal :: String
myTerminal  = "kitty"

myBrowser :: String
myBrowser   = "firefox"

myEditor :: String
myEditor    = "codium"

myCalendar :: String
myCalendar  = "gsimplecal"

myMusicPlayer :: String
myMusicPlayer = "nuclear"

myCalculator :: String
myCalculator = "qalculate-gtk"

myBorderWidth :: Dimension
myBorderWidth = 2

myUnfocusedColor :: String
myUnfocusedColor = colorBack

myFocusedColor :: String
myFocusedColor = color15

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "picom"
    spawnOnce "nitrogen --restore &"
    spawnOnce "lxsession"

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall        = renamed [Replace "tall"]
            $ windowNavigation
            $ limitWindows 12
            $ mySpacing 6
            $ ResizableTall 1 (3/100) (1/2) []

magnify     = renamed [Replace "magnify"]
            $ windowNavigation
            $ magnifier
            $ limitWindows 12
            $ mySpacing 6
            $ ResizableTall 1 (3/100) (1/2) []

monocle     = renamed [Replace "monocle"]
            $ windowNavigation
            $ limitWindows 20 Full

threeCol    = renamed [Replace "threeCol"]
            $ windowNavigation
            $ limitWindows 7
            $ ThreeCol 1 (3/100) (1/2)

threeRow    = renamed [Replace "threeRow"]
            $ windowNavigation
            $ limitWindows 7
            $ Mirror
            $ ThreeCol 1 (3/100) (1/2)

floats      = renamed [Replace "floats"]
            $ limitWindows 20 simplestFloat

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font      = "xft:Ubuntu:bold:size=60"
    , swn_fade      = 1.0
    , swn_bgcolor   = "#1C1F24"
    , swn_color     = "#FFFFFF"
    }

myLayoutHook = avoidStruts $ smartBorders $ mouseResize $ windowArrange $ T.toggleLayouts floats
             $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
                 myDefaultLayout  = withBorder myBorderWidth tall
                                ||| Main.magnify
                                ||| monocle
                                ||| threeCol
                                ||| threeRow


--             [  1(0)     2(1)     3(2)      4(3)     5(4)      6(5)      7(6) ]
myWorkspaces = [" dev ", " www ", " chat ", " mus ",  " sys ", " vbox ", " gfx "]
myWorkspaceIndicies = M.fromList $ zipWith (,) myWorkspaces [1..]

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndicies

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ className     =? "confirm"                                --> doFloat
    , className     =? "file_progress"                          --> doFloat
    , className     =? "dialog"                                 --> doFloat
    , className     =? "download"                               --> doFloat
    , className     =? "error"                                  --> doFloat
    , className     =? "Gimp"                                   --> doFloat
    , className     =? "notification"                           --> doFloat
    , className     =? "splash"                                 --> doFloat
    , className     =? "toolbar"                                --> doFloat
    , title         =? "Oracle VM VirtualBox Manager"           --> doFloat
    , className     =? "Gimp"                                   --> doShift ( myWorkspaces !! 6 )
    , (className    =? "firefox" <&&> resource =? "Dialog")     --> doFloat
    , (className    =? "firefox" <&&> appName  =? "Library")    --> doFloat
    , className     =? "nuclear"                                --> doShift ( myWorkspaces !! 3 )
    , title         =? "Qalculate!"                             --> doFloat
    , title         =? "CoreShot"                               --> doFloat
    , isFullscreen                                              --> doFullFloat
    ]

-- START_KEYS
myKeys :: [(String, X ())]
myKeys =
    -- KB_GROUP XMonad
    [ ("M-C-r",         spawn "xmonad --recompile")                 -- Recompiles XMonad
    , ("M-S-r",         spawn "xmonad --restart")                   -- Restarts XMonad
    , ("M-S-q",         io exitSuccess)                             -- Exits XMonad

    -- KB_GROUP Run Prompt
    , ("M-p",           spawn "dmenu_run -i -p \"Run: \" -fn \"Arimo Nerd Font:pixelsize=12:antiaias=true:hinting:true\"")          -- Launchs DMenu with "Run: " prompt

    -- KB_GROUP Useful Programs
    , ("M-<Return>",    spawn (myTerminal))                         -- Opens Default Terminal
    , ("M-b",           spawn (myBrowser))                          -- Opens Default Browse
    , ("M-d",           spawn (myCalendar))                         -- Opens Default Calendar
    , ("M-m",           spawn (myMusicPlayer))                      -- Opens Default Music Player
    , ("M-c",           spawn (myCalculator))                       -- Opens Default Calculator
    , ("M-<Print>",     spawn ("coreshot -s"))                      -- Runs Coreshot Selection

    -- KB_GROUP Kill Windows
    , ("M-S-c",         kill1)                                      -- Kills Focused Window
    , ("M-S-a",         killAll)                                    -- Kills all windows on current Workspace

    -- KB_GROUP Workspaces
    , ("M-.",           nextScreen)                                 -- Switch focus to next monitor
    , ("M-,",           prevScreen)                                 -- Switch focus to prev monitor
    , ("M-S-.",         shiftTo Next nonNSP >> moveTo Next nonNSP)  -- Move focused window to next Workspace
    , ("M-S-,",         shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Move focused window to prev Workspace

    -- KB_GROUP Window Navigation
    , ("M-h",         windows W.focusUp)                          -- Move focus up window stack
    , ("M-S-h",       windows W.swapUp)                           -- Swap focused window up stack
    , ("M-l",         windows W.focusDown)                        -- Move focus down window stack
    , ("M-S-l",       windows W.swapDown)                         -- Swap focused window down stack

    -- KB_GROUP Layouts
    , ("M-<Tab>",       sendMessage NextLayout)                     -- Switch to Next Layout
    , ("M-<Space>",     sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggle noborder / full
    , ("M-s",           withFocused $ windows . W.sink)             -- sink floating window into grid

    -- KB_GROUP Window Resizing
    , ("M-j",         sendMessage Shrink)                         -- Shrink window width
    , ("M-k",         sendMessage Expand)                         -- Expand window width
    , ("M-M1-j",      sendMessage MirrorShrink)                   -- Shrink window height
    , ("M-M1-k",      sendMessage MirrorExpand)                   -- Expand window height

    -- KB_GROUP Scripts
    , ("M-C-e",         spawn "~/.config/xmonad/scripts/dotfiles.sh")      -- Open my dotfiles folder in my editor
    , ("M-C-/",         spawn "~/.config/xmonad/scripts/xmonad_keys.sh")   -- Gets the Key binds set her in a nice window
    ]
    where nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))
-- END_KEYS

main :: IO ()
main = do
    xmproc0 <- spawnPipe ("xmobar -x 0 ~/.config/xmobar/xmobar.hs")
    xmproc1 <- spawnPipe ("xmobar -x 1 ~/.config/xmobar/xmobar.hs")
    xmonad $ ewmh $ docks def
        { manageHook            = myManageHook <+> manageDocks
        , modMask               = myModMask
        , terminal              = myTerminal
        , startupHook           = myStartupHook
        , layoutHook            = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces            = myWorkspaces
        , borderWidth           = myBorderWidth
        , normalBorderColor     = myUnfocusedColor
        , focusedBorderColor    = myFocusedColor
        , logHook               = dynamicLogWithPP $ xmobarPP
            { ppOutput          = \x -> hPutStrLn xmproc0 x
                                     >> hPutStrLn xmproc1 x
            , ppCurrent         = xmobarColor color06 "" . wrap ("<box type=Top width=1 color=" ++ color06 ++ ">") "</box>"
            , ppVisible         = xmobarColor color06 "" . clickable
            , ppHidden          = xmobarColor color05 "" . wrap ("<box type=Top width=1 color=" ++ color05 ++ ">") "</box>" . clickable
            , ppHiddenNoWindows = xmobarColor color05 "" . clickable
            , ppTitle           = xmobarColor color16 "" . shorten 120
            , ppSep             = " | "
            , ppUrgent          = xmobarColor color02 "" . wrap "!" "!"
            , ppOrder           = \(ws:l:t:ex) -> [ws, l]++ex++[t]
            }
        } `additionalKeysP` myKeys
