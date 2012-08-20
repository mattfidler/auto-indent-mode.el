#  Auto-Indent-Mode
 Matthew L. Fidler

## Library Information
 __auto-indent-mode.el__ --- Auto indent Minor mode

- __Filename__ --  auto-indent-mode.el
- __Description__ --  Auto Indent text on Yank/Paste
- __Author__ --  Matthew L. Fidler, Le Wang & Others
- __Maintainer__ --  Matthew L. Fidler
- __Created__ --  Sat Nov  6 11:02:07 2010 (-0500)
- __Version__ --  0.67
- __Last-Updated__ --  Mon Aug 20 12:47:13 2012 (-0500)
- __By__ --  Matthew L. Fidler
- __Update #__ --  1441
- __URL__ --  https:__github.com_mlf176f2_auto-indent-mode.el/
- __Keywords__ --  Auto Indentation
- __Compatibility__ --  Tested with Emacs 23.x

## Possible Dependencies

  None

## auto-indent-mode.el* --- Auto indent Minor mode

- __Filename__ --  auto-indent-mode.el
- __Description__ --  Auto Indent text on Yank/Paste
- __Author__ --  Matthew L. Fidler, Le Wang & Others
- __Maintainer__ --  Matthew L. Fidler
- __Created__ --  Sat Nov  6 11:02:07 2010 (-0500)
- __Version__ --  0.66
- __Last-Updated__ --  Mon Aug 20 10:30:23 2012 (-0500)
- __By__ --  Matthew L. Fidler
- __Update #__ --  1418
- __URL__ --  https:__github.com_mlf176f2_auto-indent-mode.el/
- __Keywords__ --  Auto Indentation
- __Compatibility__ --  Tested with Emacs 23.x

## About auto-indent-mode
Provides auto-indentation minor mode for Emacs.  This allows the
following: 

  - Return automatically indents the code appropriately (if enabled)

  - Pasting/Yanking indents the appropriately

  - Killing line will take off unneeded spaces (if enabled)

  - On visit file, indent appropriately, but DONT SAVE. (Pretend like
    nothing happened, if enabled)

  - On save, optionally unttabify, remove trailing white-spaces, and
    definitely indent the file (if enabled).

  - TextMate behavior of keys if desired (see below)

  - Deleting the end of a line will shrink the whitespace to just one
    (if desired and enabled)

  - Automatically indent balanced parenthetical expression, or sexp, if desired
    `auto-indent-current-pairs` or `auto-indent-next-pair` is set
    to be true (disabled by default).  This is not immediate but occurs
    after a bit to allow better responsiveness in emacs.

All of these options can be customized. (customize auto-indent)
## Installing auto-indent-mode

To use put this in your load path and then put the following in your emacs
file:

  (setq auto-indent-on-visit-file t) ;; If you want auto-indent on for files
  (require 'auto-indent-mode)


If you (almost) always want this on, add the following to ~/.emacs:


   (auto-indent-global-mode)



Excluded modes are defined in `auto-indent-disabled-modes-list`

If you only want this on for a single mode, you would add the following to
~/.emacs


  (add-hook 'emacs-lisp-mode-hook 'auto-indent-minor-mode)



You could always turn on the minor mode with the command
`auto-indent-minor-mode`
## Setting the number of spaces for indenting major modes
While this is controlled by the major mode, as a convenience,
auto-indent-mode attempts to set the default number of spaces for an
indentation for specific major mode.  

This is done by:
1. Making local variables of all the variables specified in
   `auto-indent-known-indent-level-variables` and setting them to
   auto-indent's `auto-indent-assign-indent-level`
2. Looking to see if major mode variables
   `major-mode-indent-level` and `major-mode-basic-offset` variables
   are present.  If either of these variables are present,
   `auto-indent-mode` sets these variables to the default
   `auto-indent-assign-indent-level`.   

## TextMate Meta-Return behavior
If you would like TextMate behavior of Meta-RETURN going to the
end of the line and then inserting a newline, as well as
Meta-shift return going to the end of the line, inserting a
semi-colon then inserting a newline, use the following:


  (setq auto-indent-key-for-end-of-line-then-newline "<M-return>")
  (setq auto-indent-key-for-end-of-line-insert-char-then-newline "<M-S-return>")
  (require 'auto-indent-mode)
  (auto-indent-global-mode)


This may or may not work on your system.  Many times emacs cannot
distinguish between M-RET and M-S-RET, so if you don't mind a
slight redefinition use:


  (setq auto-indent-key-for-end-of-line-then-newline "<M-return>")
  (setq auto-indent-key-for-end-of-line-insert-char-then-newline "<C-M-return>")
  (require 'auto-indent-mode)
  (auto-indent-global-mode)


If you want to insert something other than a semi-colon (like a
colon) in a specific mode, say colon-mode, do the following:


  (add-hook 'colon-mode-hook (lambda () (setq auto-indent-eol-char ":")))

## Notes about autopair-mode and yasnippet compatibility
If you wish to use this with autopairs and yasnippet, please load
this library first.
## Using specific functions from auto-indent-mode

Also if you wish to just use specific functions from this library
that is possible as well.

To have the auto-indentation-paste use:


  (autoload 'auto-indent-yank "auto-indent-mode" "" t)
  (autoload 'auto-indent-yank-pop "auto-indent-mode" "" t)
  
  (define-key global-map [remap yank] 'auto-indent-yank)
  (define-key global-map [remap yank-pop] 'auto-indent-yank-pop)
  
  (autoload 'auto-indent-delete-char "auto-indent-mode" "" t)
  (define-key global-map [remap delete-char] 'auto-indent-delete-char)
  
  (autoload 'auto-indent-kill-line "auto-indent-mode" "" t)
  (define-key global-map [remap kill-line] 'auto-indent-kill-line)
  



However, this does not honor the excluded modes in
`auto-indent-disabled-modes-list`


## Making certain modes perform tasks on paste/yank.
Sometimes, like in R, it is convenient to paste c:\ and change it to
c:/.  This can be accomplished by modifying the
`auto-indent-after-yank-hook`.

The code for changing the paths is as follows:  


(defun kicker-ess-fix-path (beg end)
    "Fixes ess path"
    (save-restriction
      (save-excursion
        (narrow-to-region beg end)
        (goto-char (point-min))
        (when (looking-at "[A-Z]:\\\\")
          (while (search-forward "\\" nil t)
            (replace-match "/"))))))
  
  (defun kicker-ess-turn-on-fix-path ()
    (interactive)
    (when (string= "S" ess-language)
      (add-hook 'auto-indent-after-yank-hook 'kicker-ess-fix-path t t)))
  (add-hook 'ess-mode-hook 'kicker-ess-turn-on-fix-path)


Another R-hack is to take of the ">" and "+" of a command line
copy. For example copying:


    > ## set up
     > availDists <- c(Normal`"rnorm", Exponential`"rexp")
     > availKernels <- c("gaussian", "epanechnikov", "rectangular",
     + "triangular", "biweight", "cosine", "optcosine")


Should give the following code on paste:


    ## set up
     availDists <- c(Normal`"rnorm", Exponential`"rexp")
     availKernels <- c("gaussian", "epanechnikov", "rectangular",
     "triangular", "biweight", "cosine", "optcosine")


This is setup by the following code snippet:


  (defun kicker-ess-fix-code (beg end)
    "Fixes ess path"
    (save-restriction
      (save-excursion
        (save-match-data
          (narrow-to-region beg end)
          (goto-char (point-min))
          (while (re-search-forward "^[ \t]*[>][ \t]+" nil t)
            (replace-match "")
            (goto-char (point-at-eol))
            (while (looking-at "[ \t\n]*[+][ \t]+")
              (replace-match "\n")
              (goto-char (point-at-eol))))))))
  
  (defun kicker-ess-turn-on-fix-code ()
    (interactive)
    (when (string= "S" ess-language)
      (add-hook 'auto-indent-after-yank-hook 'kicker-ess-fix-code t t)))
  (add-hook 'ess-mode-hook 'kicker-ess-turn-on-fix-code)
  


## FAQ
### Why isn't my mode indenting?
Some modes are excluded for compatability reasons, such as
text-modes.  This is controlled by the variable
`auto-indent-disabled-modes-list`
### Why isn't my specific mode have the right number of spaces?
Actually, the number of spaces for indentation is controlled by the
major mode. If there is a major-mode specific variable that controls
this offset, you can add this variable to
`auto-indent-known-indent-level-variables` to change the indentation
for this mode when auto-indent-mode starts.

See:

- [Understanding GNU Emacs and tabs](http:__www.pement.org/emacs_tabs.htm)
- [In Emacs how can I change tab sizes?](http:__kb.iu.edu_data_abde.html)


## History

- __20-Aug-2012__ --   Added a generic function to change the number of spaces for an indentation. Should fix issue #4. (Matthew L. Fidler)
- __20-Aug-2012__ --   Clarified documentation (Matthew L. Fidler)
- __20-Aug-2012__ --   Added some documentation about major mode indentation issues. 7-Aug-2012 Matthew L. Fidler Last-Updated: Mon Aug 20 12:47:36 2012 (-0500)
- __04-Aug-2012__ --   Added ability to turn off dynamic growth of timers per mode. The algorithm to change has not been perfected yet. (Matthew L. Fidler)
- __04-Aug-2012__ --   Fixed a bug introduced by cleaning typos. Changing again. (Matthew L. Fidler)
- __03-Aug-2012__ --   Save indentation settings on exit emacs. (Matthew L. Fidler)
- __03-Aug-2012__ --   Fixed Documentation, and a few minor bugs caught by linting. (Matthew L. Fidler)
- __30-Jul-2012__ --   Made the Fix for issue #3 more specific to org tables. (Matthew L. Fidler)
- __30-Jul-2012__ --   Actual Fix for Issue #3. Now the delete character may not work in org-mode. (Matthew L. Fidler)
- __23-Jul-2012__ --   Fix Issue #3. Thanks harrylove for pointing it out. (Matthew L. Fidler)
- __02-Jul-2012__ --   Have an mode-based timer normalized to the number of lines used for next parenthetical indentation. (Matthew L. Fidler)
- __26-Jun-2012__ --   Bug fix for point-shift involved in `auto-indent-after-yank-hook` (Matthew L. Fidler)
- __13-Jun-2012__ --   Added `auto-indent-after-yank-hook` (Matthew L. Fidler)
- __18-May-2012__ --   Changed `auto-indent-next-pair` to be off by default. (Matthew L. Fidler)
- __13-Mar-2012__ --   Made timer for parenthetical statements customizable. (Matthew L. Fidler)
- __06-Mar-2012__ --   Speed enhancements for parenthetical statements. (Matthew L. Fidler)
- __05-Mar-2012__ --   Bug fix for autopair-backspace. (Matthew L. Fidler)
- __05-Mar-2012__ --   Have backspace cancel parenthetical alignment timer canceling (Matthew L. Fidler)
- __29-Feb-2012__ --   Bug fix for paren handling. (Matthew L. Fidler)
- __29-Feb-2012__ --   Made the handling of pairs a timer-based function so it doesn't interfere with work flow. (Matthew L. Fidler)
- __29-Feb-2012__ --   Better handling of pairs. (Matthew L. Fidler)
- __28-Feb-2012__ --   Added subsequent-whole-line from Le Wang's fork. (Matthew L. Fidler)
- __14-Feb-2012__ --   Fixing issue #2 (Matthew L. Fidler)
- __01-Feb-2012__ --   Added makefile-gmake-mode to the excluded auto-indent modes. (Matthew L. Fidler)
- __22-Dec-2011__ --   Added bug fix for home-key (Matthew L. Fidler)
- __21-Dec-2011__ --   Added another smart delete case. (Matthew L. Fidler)
- __14-Dec-2011__ --   Went back to last known working `auto-indent-def-del-forward-char` and deleted message. (Matthew L. Fidler)
- __14-Dec-2011__ --   Another Paren (Matthew L. Fidler)
- __14-Dec-2011__ --   Paren Bug Fix. (Matthew L. Fidler)
- __14-Dec-2011__ --   Changed the `auto-indent-kill-remove-extra-spaces` default to nil so that you copy-paste what you expect. (Matthew L. Fidler)
- __10-Dec-2011__ --   Bug fix for annoying old debugging macros. (Matthew L. Fidler)
- __08-Dec-2011__ --   Added autoload cookie. (Matthew L. Fidler)
- __08-Dec-2011__ --   Bug fix for duplicate macros (Matthew L. Fidler)
- __08-Dec-2011__ --   Added (( and )) to the automatically delete extra whitespace at the end of a function list. (Matthew L. Fidler)
- __08-Dec-2011__ --   Added `auto-indent-alternate-return-function-for-end-of-line-then-newline` option (Matthew L. Fidler)
- __08-Dec-2011__ --   Added a possibility of adding a space if necessary. (Matthew L. Fidler)
- __08-Dec-2011__ --   Smarter delete end of line character enhancements. (Matthew L. Fidler)
- __08-Dec-2011__ --   Changed default options. (Matthew L. Fidler)
- __29-Nov-2011__ --   Bug Fix in `auto-indent-mode-pre-command-hook` (Matthew L. Fidler)
- __28-Nov-2011__ --   Bugfix for auto-indent-mode (Matthew L. Fidler)
- __21-Nov-2011__ --   Changed `auto-indent-after-begin-or-finish-sexp` to be called after every other hook has been run. That way autopair-mode should be indented correctly. (Matthew L. Fidler)
- __18-Nov-2011__ --   Added `auto-indent-after-begin-or-finish-sexp` (Matthew L. Fidler)
- __08-Apr-2011__ --   Bug fix for when Yasnippet is disabled. Now will work with it disabled or enabled. (Matthew L. Fidler)
- __08-Mar-2011__ --   Changed `auto-indent-delete-line-char-remove-extra-spaces` to nil by default. (Matthew L. Fidler)
- __16-Feb-2011__ --   Added a just one space function for pasting (Matthew L. Fidler)
- __15-Feb-2011__ --   Removed the deactivation of advices when this mode is turned off. I think it was causing some issues. (Matthew L. Fidler)
- __10-Feb-2011__ --   Added check to make sure not trying to paste on indent for `auto-indent-disabled-modes-list`  (Matthew L. Fidler)
- __03-Feb-2011__ --   Swap `backward-delete-char` with `backward-delete-char-untabify`. Also use `auto-indent-backward-delete-char-behavior` when auto-indent-mode is active.  (Matthew L. Fidler)
- __03-Feb-2011__ --   Added definition of `cua-copy-region` to advised functions (I thought it would have been taken care of with `kill-ring-save`)  (Matthew L. Fidler)
- __03-Feb-2011__ --   Added option to delete indentation when copying or cutting regions using `kill-region` and `kill-ring-save`. Also changed `auto-indent-kill-line-remove-extra-spaces` to `auto-indent-kill-remove-extra-spaces`  (Matthew L. Fidler)
- __03-Feb-2011__ --   Made sure that auto-indent-kill-line doesn't use the kill-line advice. (Matthew L. Fidler)
- __03-Feb-2011__ --    (Matthew L. Fidler)
- __03-Feb-2011__ --   Another kill-line bug-fix. (Matthew L. Fidler)
- __03-Feb-2011__ --   Fixed the kill-line bug (Matthew L. Fidler)
- __03-Feb-2011__ --   yank engine bug fix. (Matthew L. Fidler)
- __03-Feb-2011__ --   Bug fix for determining if the function is a yank (Matthew L. Fidler)
- __02-Feb-2011__ --   Added kill-line bug-fix from Le Wang. Also there is a the bug of when called as a function, you need to check for disabled modes every time.  (Matthew L. Fidler)
- __02-Feb-2011__ --   Added interactive requriment again. This time tried to back-guess if the key has been hijacked. If so assume it was called interactively.  (Matthew L. Fidler)
- __01-Feb-2011__ --   Took out the interactive requirement again. Causes bugs like org-delete-char below. (Matthew L. Fidler)
- __01-Feb-2011__ --   Bug fix for org-delete-char (and possibly others). Allow delete-char to have auto-indent changed behavior when the command lookup is the same as the delete command (as well as if it is called interactively) (Matthew L. Fidler)
- __01-Feb-2011__ --   Added bugfix to kill-line advice and function (from Le Wang) (Matthew L. Fidler)
- __01-Feb-2011__ --   Added cua-paste and cua-paste-pop (Matthew L. Fidler)
- __01-Feb-2011__ --   Added auto-indent on move up and down with the arrow keys. (Matthew L. Fidler)
- __01-Feb-2011__ --   Added a keyboard engine that indents instead of using hooks and advices. (Matthew L. Fidler)
- __01-Feb-2011__ --   Removed the interactivity in the hooks. They are definitely not interactive. (Matthew L. Fidler)
- __01-Feb-2011__ --   Added Le Wang's fixes: 
    + Many functions are checked for interactivity
    + Kill-line prefix argument is fixed
    + Kill region when region is active is controled by auto-indent-kill-line-kill-region-when-active
    + Kill-line when at eol has more options
    + Change auto-indent-indentation-function to auto-indent-newline-function  (Matthew L. Fidler)
- __31-Jan-2011__ --   Removed indirect reference to `shrink-whitespaces`. Thanks Le Wang (Matthew L. Fidler)
- __31-Jan-2011__ --   Added explicit requirement for functions (Matthew L. Fidler)
- __18-Jan-2011__ --   Added support to turn on `org-indent-mode` when inside an org-file. (Matthew L. Fidler)
- __12-Jan-2011__ --   Added fix for ortbl-minor-mode. Now it will work when orgtbl-minor mode is enabled. (Matthew L. Fidler)
- __09-Dec-2010__ --   Bugfix. Now instead of indenting the region pasted, indent the region-pasted + beginning of line at region begin and end of line at region end. (Matthew L. Fidler)
- __02-Dec-2010__ --   Last-Updated: Thu Dec 2 13:02:02 2010 (-0600) #411 (Matthew L. Fidler) Made ignoring of modes with indent-relative and indent-relative-maybe apply to indenting returns as well. (Matthew L. Fidler)
- __02-Dec-2010__ --   Removed auto-indent on paste/yank for modes with indent-relative and indent-relative-maybe. This has annoyed me forever. (Matthew L. Fidler)
- __02-Dec-2010__ --   Added an advice to delete-char. When deleting a new-line character, shrink white-spaces afterward. (Matthew L. Fidler)
- __02-Dec-2010__ --   Speed enhancement by checking for yasnippets only on indentation. (Matthew L. Fidler)
- __29-Nov-2010__ --   Bug fix to allow authotkey files to save. (Matthew L. Fidler)
- __29-Nov-2010__ --   Change auto-indent-on-save to be disabled by default. (Matthew L. Fidler)
- __22-Nov-2010__ --   Yasnippet bug-fix. (Matthew L. Fidler)
- __22-Nov-2010__ --   auto-indent bug fix for save on save buffer hooks. (Matthew L. Fidler)
- __16-Nov-2010__ --   Added conf-windows-mode to ignored modes. (Matthew L. Fidler)
- __15-Nov-2010__ --   Bugfix for deletion of whitespace (Matthew L. Fidler)
- __15-Nov-2010__ --   Bugfix for post-command-hook. (Matthew L. Fidler)
- __15-Nov-2010__ --   Added diff-mode to excluded modes for auto-indentaion. (Matthew L. Fidler)
- __15-Nov-2010__ --   Added fundamental mode to excluded modes for auto-indentation. (Matthew L. Fidler)
- __13-Nov-2010__ --   Bug fix try #3 (Matthew L. Fidler)
- __13-Nov-2010__ --   Anothe bug-fix for yasnippet. (Matthew L. Fidler)
- __13-Nov-2010__ --   Bug fix for auto-indent-mode. Now it checks to make sure that `last-command-event` is non-nil.  (Matthew L. Fidler)
- __11-Nov-2010__ --   Put back processes in. Made the return key handled by pre and post-command-hooks. (Matthew L. Fidler)
- __11-Nov-2010__ --   Took out processes such as __R__ or __eshell__ (Matthew L. Fidler)
- __09-Nov-2010__ --   Bug fix when interacting with the SVN version of yasnippet. It will not perform the line indentation when Yasnippet is running.  (Matthew L. Fidler)
- __09-Nov-2010__ --   Made sure that the auto-paste indentation doesn't work in minibuffer. (Matthew L. Fidler)
- __09-Nov-2010__ --   When `auto-indent-pre-command-hook` is inactivated by some means, add it back. (Matthew L. Fidler)
- __09-Nov-2010__ --   Added snippet-mode to excluded modes. Also turned off the kill-line by default. (Matthew L. Fidler)
- __07-Nov-2010__ --   Added the possibility of TextMate type returns. (Matthew L. Fidler)
- __07-Nov-2010__ --   Bug fix where backspace on indented region stopped working.Added TextMate (Matthew L. Fidler)
- __07-Nov-2010__ --   Another small bug fix. (Matthew L. Fidler)
- __07-Nov-2010__ --   Added bugfix and also allow movement on blank lines to be automatically indented to the correct position.  (Matthew L. Fidler)
- __06-Nov-2010__ --   Initial release.  (Matthew L. Fidler)
