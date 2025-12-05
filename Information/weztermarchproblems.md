  The conversation history indicates you've already tried:
   1. Running wezterm start --always-new-process.
   2. Killing processes with pkill -f wezterm.
   3. Trying to run with WEZTERM_LOG=debug.
   4. Renaming the config file to test a "clean" start.

  Since "none of these steps worked," we need to dig deeper into the Arch-specific context.

  Potential Arch Linux Specific Issues

   1. Wayland vs. X11: Arch defaults to Wayland on many setups (Hyprland is Wayland-only). WezTerm relies on specific Wayland protocols. If your
      environment variables aren't set correctly, it might be trying to use XWayland or failing to find the display server.
   2. Graphics Drivers: WezTerm is GPU-accelerated. Missing OpenGL drivers or issues with Mesa/Nvidia drivers can cause it to hang silently before
      rendering a window.
   3. Missing Fonts: Sometimes a missing font configuration can cause a crash if the fallback fails catastrophically (though rare).

  Updated Troubleshooting Plan for Arch/Hyprland

  Since you are likely running Hyprland (based on your dotfiles context), try these targeted steps:

  1. Verify Wayland Socket
  Ensure WezTerm knows where to display.
   1 echo $WAYLAND_DISPLAY
   2 # Should output something like 'wayland-1'
  If empty, that's the problem.

  2. Force Wayland or X11
  Try forcing WezTerm to use specific backends to see if one works.

  Force Wayland:
   1 WEZTERM_ENABLE_WAYLAND=1 wezterm start --always-new-process

  Force X11 (via XWayland):

   1 WEZTERM_ENABLE_WAYLAND=0 wezterm start --always-new-process

  3. Software Rendering (Driver Check)
  If GPU drivers are the issue, force software rendering (slow, but tests the theory).

   1 LIBGL_ALWAYS_SOFTWARE=1 wezterm start --always-new-process

  4. Check for "Headless" State
  If you are running this from a TTY or an SSH session without a graphical session active, WezTerm cannot open a window. Ensure you are inside Hyprland
  (or another GUI) when running these commands.

  What I will do
  I will use the available tools to check your wezterm.lua configuration specifically for any Arch/Linux quirks that might cause this hanging behavior,
  and check your .zshrc to ensure it's not causing the shell inside WezTerm to crash immediately.

  I'll start by reading the WezTerm config.
