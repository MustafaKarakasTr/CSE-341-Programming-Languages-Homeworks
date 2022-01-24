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
    (if (/= q 0) () (progn (terpri)(format t "INVALID INPUT") (setf (aref tokensFound 0) "INVALID") ))
    (return-from convert-string-to-integer q)
)
(define-condition end-program-condition (simple-error) ())
;;;;;;(setf (aref tokensFound indexInTokensFound) str)  (setf (aref valuesFound pointerInValues) str) (incf pointerInValues))
(defun printResult (input itIsIdentifier)
    (if (= itIsIdentifier 1) ()  (progn  (setf (aref tokensFound 0) "INVALID")))
)
(defun checkOtherElements (input)
    (if (= (length input) 1)   
        (printResult input 1); there is no other element to check
        ;else input's lenght is more than 1
        (progn 
            (setq charPointer 1)
            (setq sizeOfGivenString (length input))
            (setq stillIdentifier 1)
            (loop
            (setq wantedChar (char input charPointer))

            (if (equal (find wantedChar alphanumerics) nil)(setq stillIdentifier 0) )
            (setq charPointer (+ charPointer 1))
            (if(equal charPointer sizeOfGivenString) (progn  (printResult input stillIdentifier)(return-from checkOtherElements )))
            )
        )
))
(defun selectorIdValInvalid (input tokensFound indexInTokensFound)
    (setq stringRepresentation(string input ))
    (setq first (char stringRepresentation 0))
    (setq identifierFound 0)
    (if (equal (find first alphabet) nil)()(progn(checkOtherElements stringRepresentation)(setq identifierFound 1)))
    
    (if ( = identifierFound 0) ; it is not identifier, is It value ?
        (progn 
            (setq isItDigit (digit-char-p first))
           ; (write "ERROR")
            (if (equal isItDigit NIL)(progn (terpri)(format t "INVALID INPUT") (setf (aref tokensFound 0) "INVALID"))
                (if(/= (position isItDigit digits ) -1)
                    (progn (setq temp (convert-string-to-integer stringRepresentation ) )(if (/= temp 0) (progn (setf (aref tokensFound indexInTokensFound) "VALUE")  (setf (aref valuesFound pointerInValues) input) (incf pointerInValues)))
                    )
                )
            )
            
            
            ;(write "ERROR2")

        )
        (progn ; input is identifier save token and identifier name
            (setf (aref tokensFound indexInTokensFound) "IDENTIFIER")
            (incf  indexInTokensFound)
            ;; save identifier name, increment pointer
            (setf (aref identifiersFound pointerInIdentifiers) input)
            (incf pointerInIdentifiers)
        )
    )
)
(defun printToken (input tokensFound indexInTokensFound)
    (setq index (positionOfString keywordsOperatorsComment input))
    (if(= index -1) (selectorIdValInvalid input tokensFound indexInTokensFound)
                    ;(print(nth index  tokens))
                    (setf (aref tokensFound indexInTokensFound) (nth index  tokens))
                    )

    ;(if(= index -1) (selectorIdValInvalid input)(return-from printToken(nth index  tokens)))

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

(defvar x "")
(defun get-input (prompt)
  (clear-input)
  (write-string prompt)
  (finish-output)
  (setq x (read-line))
)
(defun func ()
    (setq qq (positionOfString keywordsOperatorsComment x) ) 
    (if (= qq -1) (write "NONOPERATOR")(write (nth qq tokens)))

)
; if the sep is operator returns index of operator in operators list (>= 0)
; if it is a whitespace returns -1
; if it is not a separator returns -2
; it is is ; it returns -3

(defun isItSeparator (sep) 
    (setq itIsWhiteSpace -1)
    ; it is whitespace
    (if (string= sep " ") (return-from isItSeparator itIsWhiteSpace)
        ;(if (string= sep ";" ) (return-from isItSeparator -3) ) ; else
    )
    
    (setq indexInOperators (positionOfString operators sep))
    (if (/= indexInOperators -1) 
        ;if
        (return-from isItSeparator indexInOperators) ; it is operator return index of operator
        ;else
        ; it is not a separator
        (return-from isItSeparator -2)
    ) 
    
)
(defun addCurrentStringToPossibleTokens (possibleTokens pointerInPossibleTokens input startIndex endIndex)
    (setq subString (subseq input startIndex endIndex))
    (setf (aref possibleTokens pointerInPossibleTokens) subString)
)

(defun takePossibleTokens (input)
    ;(removeWhiteSpaces)
   ; (checkForComments input)
    (setq input (concatenate 'string input " " )) ; last element should be space character
    (setq lengthOfInput (length input))
    (setf possibleTokens (make-array  lengthOfInput)) ; creates an array which has inputs length number of elements, input can contain this number of elements if all of the characters are tokens
    
    (setq startIndex 0)
    (setq endIndex 1)
    (setq pointerInPossibleTokens 0) ; holds index of added elements
    (doTimes (i lengthOfInput)
        (setq resultOfSep (isItSeparator (char input i ))) ; i holds index of separator if it is separator
        ;(if (= resultOfSep -3 ) ; it was ";", if the next one is also ; it means comment operator
         ;   (if (and (< i (- lengthOfInput 1)) (string= (char input (+ i 1)) ";")))
                
          ;          (setq resultOfSep (positionOfString operators ";;"  ))
       ; )
        
        ;(write (char input i ))
        ;(write ":")
        ;(write resultOfSep)
        
        (if (or (/= resultOfSep -2)(= endIndex  lengthOfInput ))
        (progn
            ;(write "if e girdi")
            ;(terpri)
            ; it is separator
            ;(if (> endIndex ))


            ;(if (/= endIndex  lengthOfInput )(decf endIndex)) ;123- de patladı
            (decf endIndex)

            ;(if (or (< resultOfSep 0) 
            ;(< 0 -2)
            ;(< 0 (- endIndex startIndex))
            ;)
            (if (= -1 (positionOfString operators (subseq input startIndex endIndex)))
            (progn
            (addCurrentStringToPossibleTokens possibleTokens pointerInPossibleTokens input startIndex endIndex); add current string to the possibleTokens
            (incf endIndex)
            ;(write "start:")
            ;(write startIndex)
            ;(terpri)
            ;(write "end:")

            ;(write endIndex)
            ;(terpri)
            (if (string= (aref possibleTokens pointerInPossibleTokens) "" )()
            (incf pointerInPossibleTokens) )
            ;(write "AAAAAAAA")
            ;(setq startIndex endIndex) ; jump over added elements, endIndex will be incremented
            ;(incf endIndex)
            (setq startIndex (+ i 1))
            ;(incf endIndex)
            ))
            (if (> resultOfSep -1) ; it was index of operator, add it
                (progn
                    (setq operator (nth resultOfSep operators))
                    (setf (aref possibleTokens pointerInPossibleTokens) operator)
                    (incf pointerInPossibleTokens) 
                    ;(incf endIndex)
                   ; (setq startIndex (+ i 1))
                )
            )
        
        ;(write startIndex)
        )

        )
        (incf endIndex ); increment endIndex of possible token
         ;(write "start:")
       ; (write startIndex)
         
         ;   (terpri)
         ;    (write "end:")
         ;   (write endIndex)
         ;   (terpri)
    )
    ;(removeElementsWhoseLengthIsZero possibleTokens)
    (return-from takePossibleTokens possibleTokens) ; return created array
)
(defun processInput(input)
    (setf possibleTokens (takePossibleTokens input))
    (setq indexInTokens 0)
    ;(setf tokensFound (make-array  (length input)))
    ;(write possibleTokens)
    (setq a 0)
    (loop
        
        (when (or (>= a (length possibleTokens)) (string= (aref possibleTokens a) NIL)) (return a))
        (setq possibleTokenElement (aref possibleTokens a)) 
        ;(if (string/= possibleTokenElement "" )
        (if (and (/= (length possibleTokenElement) 0 ) (string/= possibleTokenElement " "))
        (progn
        ;(setf (nth index tokensFound) possibleTokenElement)
        ;(setf (nth index tokensFound) (printToken possibleTokenElement))
        (printToken possibleTokenElement tokensFound indexInTokens) ; save the token
        (setq indexInTokens (+ indexInTokens 1))
        (if (string= possibleTokenElement ";;") (progn (terpri)(return a)))
        
        )
        )
        (setq a (+ a 1))
        
    )  
    
    ;(printToken x)
) 
(defun isItBool (str)
    (if (or (string= str "KW_TRUE")(string= str "KW_FALSE") )
))
(defun convertValuesIntoIntegers (valuesFound pointerInValues)
    (dotimes (i pointerInValues)
        (setf (aref valuesFound i) (parse-integer (aref valuesFound i))) ; convert each string to integer
    )

) 
(defun isThereAnyInvalid (tokensFound)
    (dotimes (j indexInTokens)
    
        (if (string= (aref tokensFound j) "INVALID")(progn (return-from isThereAnyInvalid 0) ))
    )
    (return-from isThereAnyInvalid 1)
)
(defvar fromFile -1)
(defun mainFunction(&optional (takeLine -1))
    (setq fromFile takeLine)
    
    (if (= takeLine -1)
    (progn 
    (terpri)
    (get-input "Enter line:")
    )
    )
    (setq x (string-downcase x))
    ;;(print x)
    ;(if (string= x "q")
        ;(progn
        ;    (return-from mainFunction 0) 
        ;)
        ;(write x)
        ;(func)
        
       ; (progn 
            
            (setf tokensFound (make-array  (length x)))
            (setf identifiersFound (make-array  (length x))) ;; will hold the name identifiers entered
            (setf valuesFound (make-array  (length x))) ;; will hold the values entered
            (setq pointerInValues 0)
            (setq pointerInIdentifiers 0)
            (processInput x ) ; tokens found will have the created tokens
            (if (= (isThereAnyInvalid tokensFound) 0)(return-from mainFunction 0) )
            (convertValuesIntoIntegers valuesFound pointerInValues) 
            
            (parseInput)
        ;(parseInput x)
        
        ;)
        
       ; (progn(let qq (positionOfString keywordsOperatorsComment x) ) (if (= qq -1) )(write "NONOPERATOR")(write "OPERATOR")) 
        ;;(nth  qq tokens)))
    ;)
    (if (= takeLine -1)(mainFunction))
)
(defvar ERRORFLAG -56745)
(defun parseInput ()
    (setq valPointer 0)
    (setq idenPointer 0)
    (setq tokenPointer 0)
    (prog ((tokenProcessed "")(valueTaken 0))
        (loop
            (setf tokenProcessed (aref tokensFound tokenPointer))
            (if (or (string= tokenProcessed NIL ) (string= tokenProcessed "COMMENT" )) (return 0))
            
            (setq valueTaken (processTokens)) ; processTokens returns the value found
            (if (/= valueTaken ERRORFLAG )
                    (progn 
                    (setq operationProcessed (aref tokensFound 1))
                    (if (string= operationProcessed "KW_EXIT") (progn (print "END OF PROGRAM") (exit) ) )
                    (if (and (string/= operationProcessed "KW_APPEND" )(string/= operationProcessed "KW_CONCAT"  ) (string/= operationProcessed "KW_DISP"  )(string/= operationProcessed "KW_SET")(string/= operationProcessed "KW_LIST")) (progn (print valueTaken) (terpri))) ; if it is KW_DISP, it is already printed
                    (if (= fromFile -1)
                        (progn 
                            (print "Syntax OK.")
                            (terpri)
                        )
                    )
                    
                    )
                    (progn
                       
                        (print "Unrecognized expression")
                        (exit)                        
                        (return-from parseInput 0)
                    )
            )
            
            ;(incf loopCounter)
        
        )
    )


)

;precon: tokenPointer holds the index of first token which is not processed
;postcon: tokenPointer holds the index of last token which is processed
(defvar setOperation1 (list "OP_OP" "KW_SET" "IDENTIFIER" "EXPI" "OP_CP"))
(defvar dispOperation (list "OP_OP" "KW_DISP" "EXPI" "OP_CP"))
;(defvar dispOperation2 (list "OP_OP" "KW_DISP" "EXPILIST" "OP_CP"))

(defvar listOperation1 (list "OP_OP" "KW_LIST" "EXPILIST" "OP_CP"))
(defvar setOperation2 (list "OP_OP" "KW_SET" "IDENTIFIER" "OP_OP" "KW_LIST" "EXPILIST" "OP_CP" "OP_CP"))


(defvar dispOperation2 (list "OP_OP" "KW_DISP" "IDENTIFIER" "OP_CP")); to print lists
(defvar appendOperation (list "OP_OP" "KW_APPEND" "LISTGIVEN" "EXPI" "OP_CP"))
(defvar concatOperation (list "OP_OP" "KW_CONCAT" "LISTGIVEN" "LISTGIVEN" "OP_CP"))

;(defvar ifOperation (list "OP_OP" "KW_IF" "EXPB" "EXPI" "EXPI" "OP_CP"))
(defvar exitOperation (list "OP_OP" "KW_EXIT" "OP_CP"))
;(set a (list 1 2 3))
(defun evaluateIf()
    (setq tempPointer tokenPointer)

    (setq tokenProcessed (aref tokensFound tempPointer))
    (if (string/= "OP_OP" tokenProcessed) (return-from evaluateIf ERRORFLAG))

    (incf tempPointer)
    (setq tokenProcessed (aref tokensFound tempPointer))
    (if (string/= "KW_IF" tokenProcessed) (return-from evaluateIf ERRORFLAG))
    (incf tempPointer)
    (setq temp tokenPointer)
    (setq tokenPointer tempPointer)

    (setq ifValue (takeExpb))
    (if (= ifValue  ERRORFLAG)(progn  (setq tokenPointer temp )(return-from evaluateIf ERRORFLAG)))
    (setq val1 (takeExpi))
    
    (setq val2 (takeExpi))
    (if (string/= "OP_CP" (aref tokensFound tokenPointer) ) (progn  (setq tokenPointer temp )(return-from evaluateIf ERRORFLAG)))
    (incf tokenPointer)
    (if (/= ifValue 0) (return-from evaluateIf val1) (return-from evaluateIf val2))
    

)
(defun takeExpb()
    ;(if (string= op "OP_PLUS") (return-from takeExpi (+ firstExpi secondExpi))) 
    ;(if (string= op "OP_MINUS") (return-from takeExpi (- firstExpi secondExpi))) 
    ;(if (string= op "OP_MULT") (return-from takeExpi (* firstExpi secondExpi))) 
    ;(if (string= op "OP_DIV") (return-from takeExpi (/ firstExpi secondExpi)))

    (if (string= (aref tokensFound tokenPointer) "OP_OP" )
        (progn
            (setq operation (aref tokensFound (+ tokenPointer 1)))
            (if (or (string= operation "KW_AND" )(string= operation "KW_OR" )(string= operation "KW_LESS" )(string= operation "KW_NOT" ) (string= operation "KW_EQUAL" ) ) 
                (return-from takeExpb (takeExpi))
            )
        )
    ) 
    (if (or (string= (aref tokensFound tokenPointer) "IDENTIFIER" ) (string= (aref tokensFound tokenPointer) "KW_TRUE" ) (string= (aref tokensFound tokenPointer) "KW_FALSE" ))
        (return-from takeExpb (takeExpi))
    )
    
    (return-from takeExpb ERRORFLAG)
)
(defun takeList ()
    (setq errorArr (make-array 1))
    (setf (aref errorArr 0) ERRORFLAG)
    (prog ((initialTokenPointer tokenPointer) (initialIdenPointer idenPointer) (initialValPointer valPointer))
        (if (string= (aref tokensFound initialTokenPointer) "IDENTIFIER")
            (progn ;if identifier holds list return it
                ;;  
                    (setq listName (aref identifiersFound initialIdenPointer))
                    (incf initialIdenPointer)
                    (incf initialTokenPointer)
                    (setq tempIndex (arrayIndexOf listsTakenFromUser listName))

                    (if (= tempIndex -1) 
                        (return-from takeList errorArr) ; identifier name does not hold list
                    )

                    ;(setq takenList1 (aref listIdentifierValues tempIndex))
                    (if (not takenList1) (setq takenList1 (aref listIdentifierValues tempIndex)) (setq takenList2 (aref listIdentifierValues tempIndex))) 
                    (setq takenValue 1)
                    ;(if (string/= (aref tokensFound initialTokenPointer) "OP_CP")
                    ;    (return-from takeList errorArr)
                    ;)

                    ;(incf initialTokenPointer)

                    ; it is successful

                    (setq tokenPointer initialTokenPointer)
                    (setq idenPointer initialIdenPointer )

                    (if (not takenList2) (return-from takeList takenList2))
                    (return-from takeList takenList1)
                ;;
            )
            (progn ; given as list
                        
                        (setq valueOfExpression (takeSetOperation listOperation1))
                        (if (/= valueOfExpression ERRORFLAG )
                            
                            (progn (return-from takeList takenList1)) 
                            (return-from takeList errorArr)
                        )
            )
        
        )

        
    
    )

)
(defun dispList()
    (setq initialTokenPointer tokenPointer)
    (setq initialIdenPointer idenPointer)
    (if (string/= (aref tokensFound initialTokenPointer) "OP_OP")
        (return-from dispList ERRORFLAG)
    )
    (incf initialTokenPointer)
    (if (string/= (aref tokensFound initialTokenPointer) "KW_DISP")
        (return-from dispList ERRORFLAG)
    )
    (incf initialTokenPointer)

    (if (string/= (aref tokensFound initialTokenPointer) "IDENTIFIER")
        (return-from dispList ERRORFLAG)
    )
    (incf initialTokenPointer)

    (setq listName (aref identifiersFound initialIdenPointer))
    (incf initialIdenPointer)

    (setq tempIndex (arrayIndexOf listsTakenFromUser listName))
    (if (= tempIndex -1) 
        (return-from dispList ERRORFLAG) ; identifier name does not hold list
    )
    (setq listToDisplay (aref listIdentifierValues tempIndex))
    (if (string/= (aref tokensFound initialTokenPointer) "OP_CP")
        (return-from dispList ERRORFLAG)
    )
    (incf initialTokenPointer)
    ; it is successful

    (setq tokenPointer initialTokenPointer)
    (setq idenPointer initialIdenPointer )

    (print listToDisplay)
    
    
    (return-from dispList 1)
    
)
(defun takeExit ()
    (setq tokenProcessed (aref tokensFound tokenPointer))
    (setq tempPointer tokenPointer)
    (if (string/= "OP_OP" tokenProcessed) (return-from takeExit ERRORFLAG) )
    (incf tempPointer)
    (setq tokenProcessed (aref tokensFound tempPointer))

    (if (string/= "KW_EXIT" tokenProcessed) (return-from takeExit ERRORFLAG))
    (incf tempPointer)

    (setq tokenProcessed (aref tokensFound tempPointer))
    (if (string/= "OP_CP" tokenProcessed) (return-from takeExit ERRORFLAG))

    (setq tokenPointer tempPointer)
    (setq tokenPointer (+ tokenPointer 1))
    (return-from takeExit 1)
)
(defun processTokens ()
    (if (< (length tokensFound )3) (progn (print "Insufficient input" ) (exit)))
    (setq operation (aref tokensFound 2)) ;; save operation
    (if ( and (< (length tokensFound) 4 )(string/= operation "KW_EXIT") ) (progn (print "Insufficient input" ) (exit)))
    (prog ((valueOfExpression ERRORFLAG))
        
        (setq valueOfExpression (takeExit)) 
        (if (/= valueOfExpression ERRORFLAG ) (return-from processTokens valueOfExpression))
        
        (setq valueOfExpression (dispList)) 
        (if (/= valueOfExpression ERRORFLAG ) (return-from processTokens valueOfExpression))

        (setq valueOfExpression (evaluateIf)) 
        (if (/= valueOfExpression ERRORFLAG ) (return-from processTokens valueOfExpression))

        (setq valueOfExpression (takeExpi))
        (if (/= valueOfExpression ERRORFLAG ) (return-from processTokens valueOfExpression) )

        (setq takenList1 NIL)
        (setq takenList2 NIL)
        (setq valueOfExpression (takeSetOperation appendOperation)) 
        (if (/= valueOfExpression ERRORFLAG ) (return-from processTokens valueOfExpression))

        (setq takenList1 NIL)
        (setq takenList2 NIL)
        (setq valueOfExpression (takeSetOperation concatOperation)) 
        (if (/= valueOfExpression ERRORFLAG ) (return-from processTokens valueOfExpression))

        (setq takenList1 NIL)
        (setq takenList2 NIL)
        (setq valueOfExpression (takeSetOperation setOperation1))
        (if (/= valueOfExpression ERRORFLAG ) (return-from processTokens valueOfExpression))

        (setq takenList1 NIL)
        (setq takenList2 NIL)   
        (setq valueOfExpression (takeSetOperation dispOperation))
        (if (/= valueOfExpression ERRORFLAG )(return-from processTokens valueOfExpression))
;(takenList1 NIL)   
 (setq takenList1 NIL)
    (setq takenList2 NIL)
        (setq valueOfExpression (takeSetOperation listOperation1))
        (if (/= valueOfExpression ERRORFLAG )(progn (return-from processTokens valueOfExpression)))
    (setq takenList1 NIL)
    (setq takenList2 NIL)
        (setq valueOfExpression (takeSetOperation setOperation2))
        (if (/= valueOfExpression ERRORFLAG )(return-from processTokens valueOfExpression))

        (return-from processTokens ERRORFLAG)
    )
)
             ;; else
            
     ;; else
            
        
     

;(defun strcmp (str1,str2)
;    (return-from strcmp (string= str1 str2))
;)
(defun resize (arrayToResize)
    (prog ((counter 0))
        (setq tempArray (make-array (* 2 (length arrayToResize))))
        (loop
            (if (= counter (length arrayToResize)) (return-from resize tempArray))
            (setf (aref tempArray counter ) (aref arrayToResize counter))
            (incf counter)
        
        )
    )
)
(defun  removeIndex (arrayGiven index) 
    (setf (aref arrayGiven index) "#")
)
(defvar listsTakenFromUser (make-array 1))
(defvar listIdentifierValues (make-array 1))
(defvar sizeOfListIdentifiersTakenFromUser 0)
(defun saveListIdentifier (identifierName valueOfId)
    (setq indexOfIdentifier (arrayIndexOf listsTakenFromUser identifierName))
    (if (/= indexOfIdentifier -1) (progn (setf (aref listIdentifierValues indexOfIdentifier) valueOfId) (return-from saveListIdentifier) ))
    ; if there is a identifier with the same name, delete it
    (setq indexOfIdentifierDefined (arrayIndexOf identifiersTakenFromUser identifierName))
    (if (/= indexOfIdentifierDefined -1) (progn (removeIndex identifiersTakenFromUser indexOfIdentifierDefined )))

    (if (= sizeOfListIdentifiersTakenFromUser (length listsTakenFromUser))
        (progn 
            (setq listsTakenFromUser (resize listsTakenFromUser))
            (setq listIdentifierValues (resize listIdentifierValues))
        )
    )
    (setf (aref listsTakenFromUser sizeOfListIdentifiersTakenFromUser) identifierName )
    (setf (aref listIdentifierValues sizeOfListIdentifiersTakenFromUser) valueOfId  )
    (incf sizeOfListIdentifiersTakenFromUser)
)
(defun saveTakenList (takenList)


)
(defun resizeTakenList (arrayToResize)
    (prog ((counter 0))
        (setq tempArray (make-array (+ 1 (length arrayToResize))))
        (loop
            (if (= counter (length arrayToResize)) (return-from resizeTakenList tempArray))
            (setf (aref tempArray counter ) (aref arrayToResize counter))
            (incf counter)
        
        )
    )
)
(defun arrayIndexOf (arrayGiven elementGiven)
    (prog ((index 0)(len (length arrayGiven)))
        (loop 
            (if (= index len) (return-from arrayIndexOf -1))
            (if (string= elementGiven  (aref arrayGiven index)) (return-from arrayIndexOf index))
            (incf index)
        )
    )
)
;(defvar listsTakenFromUser (make-array 1))
;(defvar listIdentifierValues (make-array 1))

(defvar identifiersTakenFromUser (make-array 1))
(defvar identifierValues (make-array 1))
(defvar sizeOfIdentifiersTakenFromUser 0)
(defun saveIdentifier (identifierName valueOfId )
    (setq indexOfIdentifier (arrayIndexOf identifiersTakenFromUser identifierName))
    (if (/= indexOfIdentifier -1) (progn (setf (aref identifierValues indexOfIdentifier) valueOfId) (return-from saveIdentifier) ))
    ; if there is a list with the same name, delete it
    (setq indexOfIdentifierDefined (arrayIndexOf listsTakenFromUser identifierName))
    (if (/= indexOfIdentifierDefined -1) (progn (removeIndex listsTakenFromUser indexOfIdentifierDefined )(setf (aref listIdentifierValues indexOfIdentifierDefined) NIL) ))
;
    (if (= sizeOfIdentifiersTakenFromUser (length identifiersTakenFromUser))
        (progn 
            (setq identifiersTakenFromUser (resize identifiersTakenFromUser))
            (setq identifierValues (resize identifierValues))
        )
    )
    (setf (aref identifiersTakenFromUser sizeOfIdentifiersTakenFromUser) identifierName )
    (setf (aref identifierValues sizeOfIdentifiersTakenFromUser) valueOfId  )
    (incf sizeOfIdentifiersTakenFromUser)
)
;"OP_OP" "KW_LIST" "EXPILIST" "OP_CP"

(defun takeSetOperation (tokensWanted)
    (setq operation "")

    (prog ((indexOfToken 0) (currentToken "")(wantedToken "")(tempPointer tokenPointer)(settedValue 0)(takenValue)) ;; tempPointer holds the tokenPointers first value
        (loop
            (if (= indexOfToken (length tokensWanted))(return settedValue) ) 
            (setq wantedToken (nth  indexOfToken tokensWanted))
            (if (string= wantedToken "EXPI") 
                (setq takenValue (takeExpi))
                ;else
                (progn
                    (if (string= wantedToken "EXPILIST") 
                        (progn (if (not takenList1) (setq takenList1 (takeExpiList)) (setq takenList2 (takeExpiList))) (if (string= (aref tokensFound 1) "KW_LIST")  (progn (print takenList1)) )(setq takenValue 1)); takenValue 1 so it knows operation is successful
                        (progn 
                            (if (string= wantedToken "LISTGIVEN") (setq takenValue (takeList)) 
                            ;else
                                (if (string= wantedToken (aref tokensFound tokenPointer))
                                    (progn 
                                        (if (string= wantedToken "IDENTIFIER") (incf idenPointer)) ; idenPointer shows the next identifier which needs to be evaluated, because of that we already evaluate it (it is the identifier which will be setted  because only set grammer have identifiers in it) we jump over it by incerementing idenPointer by 1, 
                                        (incf tokenPointer)
                                    )
                                    ;else
                                        (progn (setq tokenPointer tempPointer)(return-from takeSetOperation ERRORFLAG))
                                )
                            )
                        )
                    )
                )
            
            )
            (incf indexOfToken)
        )
        
        (setq operation (nth  1 tokensWanted))
        (if (string= operation "KW_APPEND")
            (progn 
                ;(print "Appended:")
                
                ;(print (append takenList1 takenValue))
                (setq takenList1 (resizeTakenList takenList1))
                (setf (aref takenList1 (- (length takenList1) 1) ) takenValue)
                (print takenList1 )
            )
        )
        (if (string= operation "KW_CONCAT")
            (progn
                ;(print "CONCATTED:")
                (setq merged (make-array (+ (length takenList1)(length takenList2 ))))
                (setq arrCopied takenList1)
                (prog ((i 0)(j 0))
                    (loop
                        (if (= i (length merged)) (return ))
                        (setf (aref merged i) (aref arrCopied j))
                        (incf j)
                        (incf i)

                        (if (= j (length arrCopied) ) (progn (setq j 0) (setq arrCopied takenList2)))

                    )
                )
                
                (print merged)
            )
            
        
        )
        (if (string= operation "KW_SET")
            (if (not takenList1)
                (saveIdentifier (aref identifiersFound 0) takenValue )
                (saveListIdentifier  (aref identifiersFound 0) takenList1)
            )
        )
        ;(print "LISTELER")
        ;(print listsTakenFromUser)
        ;(print listIdentifierValues)
        (if (string= operation "KW_DISP") (progn (format t "Result: ~d" takenValue) (terpri)))
        ;(print "identifiersTakenFromUser:")
        ;(print identifiersTakenFromUser)
       ; (print identifierValues)


        ;(return-from takeSetOperation takenValue)
        (return-from takeSetOperation 1)

        ;(if (< (- pointerInPossibleTokens tokenPointer) (length tokensWanted)) (return-from takeSetOperation ERRORFLAG))
        ; else
        ;(setq wantedToken (aref tokensWanted indexOfToken))
        ;(setq currentToken (aref tokensFound tokenPointer))
        ;(if (string= wantedToken currentToken)
        ;(
            ;(progn 
            ;    ()
            ;)
        ;)

    )

)
(defun isItExpiOperator (str)
    (if (or (string= str "OP_PLUS") (string= str "OP_MINUS" )(string= str "OP_MULT" ) (string= str "OP_DIV" )(string= str "KW_AND" )(string= str "KW_OR" )(string= str "KW_EQUAL" )(string= str "KW_LESS" )(string= str "KW_NOT" )) 
        (return-from isItExpiOperator t) 
        (return-from isItExpiOperator NIL)
    )
)
(defun itIsNotExpi()
    ;(if (string= (aref tokensFound tokenPointer) "IDENTIFIER")()())
    (print "Identifier not found")
    (return-from itIsNotExpi ERRORFLAG)
)
(defun takeIdentifierValue (nameOfIdentifier)
    (prog ((indexVal -1))

        (setq indexVal (arrayIndexOf identifiersTakenFromUser nameOfIdentifier))
        (if (/= indexVal -1 )(return-from takeIdentifierValue (aref identifierValues indexVal)))
        (print "Uninitialized identifier"); this condition will never happen, if all identifiers copied correctly.
        (return-from takeIdentifierValue ERRORFLAG)
    )

)
(defun takeExpiList ()
    (setq takenList (make-array 1))

    (prog ((val 0 )(size 0))

        (loop
            (setq val (takeExpi))
            (if (= val ERRORFLAG ) (return-from takeExpiList takenList))
            (if (= size (length takenList) )(setq takenList (resizeTakenList takenList)))
            (setf (aref takenList size ) val)
            (incf size)
        
        )
    )


)
;returns the value of expi if it is available, tokenPointer holds the next element to processed 
(defun takeExpi()
    (prog ((tokenProcessed "")(valueOfExpi 0)(tempPointer 0)(firstExpi 0)(secondExpi 0)(firstValOfPointer tokenPointer) (nameOfIdentifier ""))
        (setf tokenProcessed (aref tokensFound tokenPointer))
        (if (string= tokenProcessed "VALUE") (progn (incf tokenPointer)(setq valueOfExpi (aref valuesFound valPointer) )(incf valPointer)(return-from takeExpi valueOfExpi)))
        (if (string= tokenProcessed "KW_TRUE") (progn (incf tokenPointer)(setq valueOfExpi 1 )(return-from takeExpi valueOfExpi)))
        (if (string= tokenProcessed "KW_FALSE") (progn (incf tokenPointer)(setq valueOfExpi 0 )(return-from takeExpi valueOfExpi)))

        
        (if (string= tokenProcessed "IDENTIFIER")
            (progn
                
                ;(setq valueOfExpi (takeIdentifierValue (aref  identifiersTakenFromUser (arrayIndexOf identifiersTakenFromUser )))) ; iden pointer holds the index of identifier whose value is needed. 
                (setq valueOfExpi (takeIdentifierValue (aref  identifiersFound idenPointer))) ; iden pointer holds the index of identifier whose value is needed. 
                
                (if (/= valueOfExpi ERRORFLAG) (progn (incf idenPointer) (incf tokenPointer))) 
                (return-from takeExpi valueOfExpi)
            )
        )
        ;(if (string= tokenProcessed "IDENTIFIER")( progn (incf tokenPointer) (setq nameOfIdentifier (aref identifiersFound idenPointer) )(incf idenPointer) (setq valueOfExpi (takeIdentifierValue nameOfIdentifier) ) (return-from takeExpi valueOfExpi)))
        (if (string= tokenProcessed "OP_OP")
            (progn
                
                (setq tempPointer (incf tokenPointer)) ;; token pointer is also holds next element after the OP_OP, temp pointer will hold index of operator
                (if (< tempPointer (-  pointerInPossibleTokens  3) ) ;pointerInPossibleTokens holds number of tokens, because (+ 1 2) have 4 other elements after then ( and we incermeented pointer, - 3 
                    (if (isItExpiOperator (aref tokensFound tempPointer))
                        (progn


                        (setq tokenPointer (+ tempPointer 1))
                        (setq firstExpi (takeExpi))
                        (if (= firstExpi ERRORFLAG) 
                            (progn 
                                ;(decf tokenPointer) ; if it is not found last unprocessed token pointer will holds first unprocessed token's index 
                                (return-from takeExpi (itIsNotExpi))
                            )
                            ; if first expi is taken correctly , token pointer holds the first unprocessed token's index 
                            (progn 
                                ;(setq tokenPointer (+ tempPointer 2))
                                (if (string= "KW_NOT" (aref tokensFound tempPointer)) (setq secondExpi 0) (setq secondExpi (takeExpi))) 
                                ; usttekı if dogruysa ıkıncı takExpi yı calıstırma içine 0 at asagıda sadece 1. nın degerını kullan
                                
                                (if (= secondExpi ERRORFLAG) 
                                    (progn 
                                        ;(decf tokenPointer) 
                                        (return-from takeExpi (itIsNotExpi))
                                    )
                                    ; if second expi is taken correctly 
                                    (progn
                                        ;;(setq tokenPointer (+ tempPointer 3))
                                        (if (string= (aref tokensFound tokenPointer) "OP_CP")
                                            (progn
                                                (incf tokenPointer)
                                                (setq op (aref tokensFound tempPointer))
                                                (if (string= op "OP_PLUS") (return-from takeExpi (+ firstExpi secondExpi))) 
                                                (if (string= op "OP_MINUS") (return-from takeExpi (- firstExpi secondExpi))) 
                                                (if (string= op "OP_MULT") (return-from takeExpi (* firstExpi secondExpi))) 
                                                (if (string= op "OP_DIV") (return-from takeExpi (/ firstExpi secondExpi)))
                                                (if (string= op "KW_AND") (return-from takeExpi (logand firstExpi secondExpi)))
                                                (if (string= op "KW_OR") (return-from takeExpi (logior firstExpi secondExpi)))
                                                (if (string= op "KW_EQUAL") (if (= firstExpi secondExpi ) (return-from takeExpi 1)(return-from takeExpi 0)))
                                                (if (string= op "KW_LESS") (if (< firstExpi secondExpi ) (return-from takeExpi 1)(return-from takeExpi 0)))
                                                (if (string= op "KW_NOT") (if (= firstExpi 0) (return-from takeExpi 1)(return-from takeExpi 0)))


;  "KW_AND" "KW_OR" 
; "KW_NOT" "KW_EQUAL" "KW_LESS"
                                            )                                            

                                            (progn (print "Expression is not closed") (return-from takeExpi ERRORFLAG))
                                        )

                                    )
                                )   
                            )
                        )
                    )
                )
            )
        
        )
    )
    (setq tokenPointer firstValOfPointer)
    )
    (return-from takeExpi ERRORFLAG)


)

(defun gppinterpreter (&optional (filename "1"))
	(if (string=  filename "1")
		(mainFunction)
		(let ((in (open filename :if-does-not-exist nil)))
   			(when in
      			(loop for line = (read-line in nil)
      
      			while line do (progn (setq x line)(if (or (string= x NIL ) (< (length x ) 2))() (mainFunction 0))))
      			(close in)
   			)
		)
	)
)
(get-input "Enter 1 to use interpreter, Enter file name to interpret file: " )
(gppinterpreter x)
;(if (string= x )
;(mainFunction)