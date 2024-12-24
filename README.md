# bcl-mode
## Introduction
The bcl-mode Emacs package is a major mode for
[BCL](https://github.com/galdor/bcl-specification) (Block-based Configuration
Language) files.

It provides minimal syntax highlighting and block indentation.

## Usage
You can install bcl-mode as any other Emacs package. If you are using
[Straight](https://github.com/radian-software/straight.el) (and you should), it is as simple as:
```lisp
(use-package bcl-mode
  :straight (:type git :host github :repo "galdor/bcl-mode"))
```

With Emacs 29, you can either run `package-vc-install` manually or install
[vc-use-package](https://github.com/slotThe/vc-use-package) and use use-package:
```lisp
(use-package bcl-mode
  :vc (:fetcher github :repo "galdor/bcl-mode"))
```

Finally with Emacs 30 you will not need any additional package:
```lisp
(use-package bcl-mode
  :vc (:url "https://github.com/galdor/bcl-mode"))
```

## Licensing
The bcl-mode package is open source software distributed under the
[ISC](https://opensource.org/licenses/ISC) license.

## Contact
If you have an idea or a question, feel free to email me at
<nicolas@n16f.net>.
