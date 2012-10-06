import XMonad
import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS

import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders(smartBorders)

import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.Scratchpad

import XMonad.Prompt
import XMonad.Prompt.Shell(shellPrompt)
import XMonad.Prompt.Window

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

import System.IO(hPutStrLn)

-- Things that should always float
myFloatHook = composeAll [
	className =? "qemu" --> doFloat
	, title =? "xfce4-notifyd" --> doIgnore
	, isFullscreen --> doFullFloat
	]

myLayoutHook = tiled ||| Grid ||| simpleTabbed
	where
		-- default tiling algorithm partitions the screen into two panes
		tiled   = Tall nmaster delta ratio

		-- The default number of windows in the master pane
		nmaster = 1

		-- Default proportion of screen occupied by master pane
		ratio   = 1/2

		-- Percent of screen to increment by when resizing panes
		delta   = 3/100

main = do
	xmproc <- spawnPipe "xmobar"
	xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
			{ manageHook = manageDocks <+> myFloatHook <+> manageHook defaultConfig <+> scratchpadManageHook (W.RationalRect 0.25 0.25 0.5 0.5)
			, layoutHook = avoidStruts $ smartBorders myLayoutHook
			, logHook    = dynamicLogWithPP $ xmobarPP
				{ ppOutput = hPutStrLn xmproc
				, ppUrgent = xmobarColor "#e5786d" "" . wrap "**" "**"
				, ppTitle  = xmobarColor "#95e454" "" . shorten 80
				}
			, terminal = "xterm"
			, modMask = mod4Mask
			, handleEventHook = fullscreenEventHook
			}
			`additionalKeysP`
			[ ("M-p", shellPrompt defaultXPConfig { position = Top })
			, ("M-S-a", windowPromptGoto defaultXPConfig { position = Top })
			, ("M-a", windowPromptBring defaultXPConfig { position = Top })
			, ("M-S-l", spawn "~/bin/lock")
			, ("M-S-<Left>", shiftToPrev)
			, ("M-S-<Right>", shiftToNext)
			, ("M-<Up>", windows W.focusUp)
			, ("M-S-<Up>", windows W.swapUp)
			, ("M-<Down>", windows W.focusDown)
			, ("M-S-<Down>", windows W.swapDown)
			, ("M-`", toggleWS)
			, ("M-s", moveTo Next EmptyWS)
			, ("M-S-s", shiftTo Next EmptyWS)
			, ("M-g", scratchpadSpawnAction defaultConfig { terminal = "xterm" })
			, ("<XF86Launch1>", spawn "chromium")
			]
