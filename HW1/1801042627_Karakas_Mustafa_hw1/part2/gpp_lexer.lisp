;;Keywords: and, or, not, equal, less, nil, list, append, concat,set, deffun, for, if, exit, load, disp, true, false
(defvar digits (list 1 2 3 4 5 6 7 8 9 0 ))
(defvar alphanumerics "qwertyuopilkjhgfdsazxcvbnmQWERTYUOPILKJHGFDSAZXCVBNM1234567890")
(defvar alphabet "qwertyuopilkjhgfdsazxcvbnmQWERTYUOPILKJHGFDSAZXCVBNM")
(defvar keywords (list "and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "deffun" "for" "if" "exit" "load" "disp" "true" "false"))
;;Operators: + - / * ( ) ** “ “ ,
(defvar operators(list "+" "-" "/" "*" "(" ")" "**"  "\"" "\"" ","))
(defvar commentOp ";;")
(defvar keywordsOperatorsComment(list "and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "deffun" "for" "if" "exit" "load" "disp" "true" "false" "+" "-" "/" "*" "(" ")" "**"  "\"" "\"" "," ";;"))
(defvar tokens (list "KW_AND" "KW_OR" 
"KW_NOT" "KW_EQUAL" "KW_LESS" "KW_NIL" "KW_LIST" 
"KW_APPEND" "KW_CONCAT" "KW_SET" "KW_DEFFUN" "KW_FOR" 
"KW_IF" "KW_EXIT" "KW_LOAD" "KW_DISP" "KW_TRUE" "KW_FALSE"
"OP_PLUS" "OP_MINUS" "OP_DIV"  "OP_MULT" "OP_OP" "OP_CP" "OP_DBLMULT" "OP_OC" "OP_CC" "OP_COMMA" "COMMENT"))
(defun giveToken (input)
    (setq index (positionOfString tokens input))
    (setq x "notAvailable")
    (if (= index -1 )() (return (nth index tokens)))
    (return x)
)
;I took this code from internet and modified it to check if the taken string holds integer
(defun convert-string-to-integer (str &optional (radix 10)) 
  ;"Given a digit string and optional radix, return an integer." 
  (setq q 1)
  (do ((j 0 (+ j 1)) 
       (n 0 (+ (* n radix) 
               (or (digit-char-p (char str j) radix) 
                   ;(error "Bad radix-~D digit: ~C" 
                          ;radix 
                          ;(char str j))
                    (setq q 0)
                          )))) 
      ((= j (length str)) n))
    (if (/= q 0)(print "VALUE")(progn (terpri)(format t "INVALID INPUT")))
)

(defun printResult (input itIsIdentifier)
    (if (= itIsIdentifier 1) (print "IDENTIFIER") (print "INVALID INPUT ") )
)
(defun checkOtherElements (input)
    (setq charPointer 1)
    (setq sizeOfGivenString (length input))
    (setq stillIdentifier 1)
    (loop
        (setq wantedChar (char input charPointer))

        (if (equal (find wantedChar alphanumerics) nil)(setq stillIdentifier 0) )
        (setq charPointer (+ charPointer 1))
        (if(equal charPointer sizeOfGivenString) (progn  (printResult input stillIdentifier)(return)))
    )
)
(defun selectorIdValInvalid (input)

    (setq first (char input 0))
    (setq identifierFound 0)
    ;(if (equal (find first alphabet) nil)()(progn(print "IDENTIFIER")(setq identifierFound 1)))
    (if (equal (find first alphabet) nil)()(progn(checkOtherElements input)(setq identifierFound 1)))
    
    (if ( = identifierFound 0) ; it is not identifier, is It value ?
        (progn 
            (setq isItDigit (digit-char-p first))
   
            (if(/= (position isItDigit digits ) -1)(convert-string-to-integer input ))
        )
    )
)
(defun printToken (input)
    (terpri)
    (format t "~s : "  input)
    (setq index (positionOfString keywordsOperatorsComment input))
    (if(= index -1) (selectorIdValInvalid input)
    (print(nth index  tokens))
    )
)
(defun printList(listP)
    (setq size (length listP))
    (setq index 0)
    (loop
        (write (nth index listP))
        (terpri)
        (setq index (+ index 1))
        (if(equal index size) (return))

    )
)
; returns position of the string if it is not in the list returns -1
(defun positionOfString (listP searchedString)
    (setq size (length listP))
    (setq index 0)
    (loop
        (setq nthElement (nth index listP))
        (if(string= searchedString nthElement)(return index))
        (setq index (+ index 1))
        (if(equal index size) (return -1 ))

    )
)
(defun testGivenList (testList)

    (setq sizeList (length testList))
    (setq pointerList 0)
    (loop

        (printToken (nth pointerList testList))
        (setq pointerList (+ pointerList 1))
        (terpri)
        (if(equal pointerList sizeList) (return))

    )
)
;;(print tokens)
;;(let i 0)
;(defvar lenTokens(length '(tokens)) )
;(defvar lenkeywordsOperatorsComment(length '(tokens)) )
(defvar lenTokens 0)
(defvar lenkeywordsOperatorsComment 0)

(dolist (e tokens)(setq lenTokens (+ lenTokens 1)))
(dolist (e keywordsOperatorsComment)(setq lenkeywordsOperatorsComment (+ lenkeywordsOperatorsComment 1)))
(defvar index 0)
;(defvar test1ValidTokens (list "and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "deffun" "for" "if" "exit" "load" "disp" "true" "false"))
(defvar test1ValidTokens (list "and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "deffun" "for" "if" "exit" "load" "disp" "true" "false" "+" "-" "/" "*" "(" ")" "**"  "\"" "\"" "," ";;"))
(testGivenList test1ValidTokens)

(setq wanted "1432")
(printToken wanted)
(terpri)
(setq wanted "5")
(printToken wanted)
(terpri)


(setq  wanted "6invalidIdentifier")
(printToken wanted)
(terpri)


(setq wanted "123invalid")
(printToken wanted)
(terpri)
(setq wanted "func")
(printToken wanted)
(terpri)
(setq wanted "nva,lid")
(printToken wanted)
(terpri)
(setq wanted "identifier123")
(printToken wanted)
;(print(parse-integer "5a"))
;(print(parse-integer "5"))
;(if(=(numberp "123") t) ((print "yey")))
;(setq wanted "anda")
;(setq charTemp (char "anda" 0))
;(if (equal (find charTemp "anda") nil)()(print "IDENTIFIER"))