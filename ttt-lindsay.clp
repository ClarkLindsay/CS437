(deffacts New-Board
(Board 1 Empty)
(Board 2 Empty)
(Board 3 Empty)
(Board 4 Empty)
(Board 5 Empty)
(Board 6 Empty)
(Board 7 Empty)
(Board 8 Empty)
(Board 9 Empty)
)

(deffunction MakeMove (?n ?p ?vs ?o)
  (assert (MakeMove ?n ?p vs ?o))
  (run)
)

(deffunction OpMove (?n ?o ?vs ?p ?pos)
  (assert (OpMove ?n ?o vs ?p ?pos))
  (run)
)

(defrule OpMov
  (declare (salience 1000))
  (OpMove ?n ?o vs ?p ?pos)
  ?state <- (Board ?pos Empty)
  =>
  (retract ?state)
  (assert (Board ?pos ?o))
  (println ?o "->" ?pos)
  (halt)
)

(defrule PlayMiddle
  "Play the middle if open"
  (declare (salience 150))
  (MakeMove ?n ?p vs ?o)
  ?state <- (Board 5 Empty)
  =>
  (retract ?state)
  (assert (Board 5 ?p))
  (println ?p "->5")
  (halt)
)

(defrule PlayCorner
  "Play a corner if open"
  (declare (salience 200))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      ?state <- (Board ?pos&1 Empty)
      (Board =(+ ?pos 2) Empty)
      (Board =(+ ?pos 6) Empty)
    )
    (and
      ?state <- (Board ?pos&3 Empty)
      (Board =(- ?pos 2) Empty)
      (Board =(+ ?pos 6) Empty)
    )
    (and
      ?state <- (Board ?pos&7 Empty)
      (Board =(+ ?pos 2) Empty)
      (Board =(- ?pos 6) Empty)
    )
    (and
      ?state <- (Board ?pos&9 Empty)
      (Board =(- ?pos 2) Empty)
      (Board =(- ?pos 6) Empty)
    )
   )
  =>
  (retract ?state)
  (assert (Board ?pos ?p))
  (println ?p "->" ?pos)
  (halt)
)

(defrule VerticalRule
    "If player has already played on the top or bottom, play the middle on that column
    This rule is based on code suggested by Antony Sanchez in the D2L discussion"
    (declare (salience 100))
    (MakeMove ?n ?p vs ?o)
    (or
      (and
        (Board ?pos&1|2|3 ?p)
        ?state <- (Board ?newPos&=(+ ?pos 3) Empty)
        (Board =(+ ?pos 6) Empty)
      )
      (and
        (Board ?pos&7|8|9 ?p)
        ?state <- (Board ?newPos&=(- ?pos 3) Empty)
        (Board =(- ?pos 6) Empty)
       )
     )
    =>
    (retract ?state)
    (assert (Board ?newPos ?p))
    (println ?p "->" ?newPos)
  ;  (assert (CloseToWinVertical))
  ; These types of assertions had to be moved to their own rules
    (halt)
)

(defrule HorizontalRule
  "If player has already played left or right, play the middle on that row"
  (declare (salience 100))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|4|7 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 1) Empty)
      (Board =(+ ?pos 2) Empty)
    )
    (and
      (Board ?pos&3|6|9 ?p)
      ?state <- (Board ?newPos&=(- ?pos 1) Empty)
      (Board =(- ?pos 2) Empty)
     )
   )
  =>
  (retract ?state)
  (assert (Board ?newPos ?p))
  (println ?p "->" ?newPos)
  ; (assert (CloseToWinHorizontal))
  (halt)
)

(defrule Diag1Rule
  "If player has already played on diagonal 1, play that diagonal"
  (declare (salience 100))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 4) Empty)
      (Board =(+ ?pos 8) Empty)
    )
    (and
      (Board ?pos&9 ?p)
      ?state <- (Board ?newPos&=(- ?pos 4) Empty)
      (Board =(- ?pos 8) Empty)
     )
   )
  =>
  (retract ?state)
  (assert (Board ?newPos ?p))
  (println ?p "->" ?newPos)
  ; (assert (CloseToWinDiagonal1))
  (halt)
)

(defrule Diag2Rule
  "If player has already played on diagonal 2, play that diagonal"
  (declare (salience 100))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&3 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 2) Empty)
      (Board =(+ ?pos 4) Empty)
    )
    (and
      (Board ?pos&7 ?p)
      ?state <- (Board ?newPos&=(- ?pos 2) Empty)
      (Board =(- ?pos 4) Empty)
     )
   )
  =>
  (retract ?state)
  (assert (Board ?newPos ?p))
  (println ?p "->" ?newPos)
  ; (assert (CloseToWinDiagonal2))
  (halt)
)

(defrule CheckCloseToWinVertical
  (declare (salience 500))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|2|3 ?p)
      (Board =(+ ?pos 3) ?p)
      (Board =(+ ?pos 6) Empty)
    )
    (and
      (Board ?pos&1|2|3 ?p)
      (Board =(+ ?pos 6) ?p)
      (Board =(+ ?pos 3) Empty)
    )
    (and
      (Board ?pos&7|8|9 ?p)
      (Board =(- ?pos 3) ?p)
      (Board =(- ?pos 6) Empty)
    )
    (and
      (Board ?pos&7|8|9 ?p)
      (Board =(- ?pos 6) ?p)
      (Board =(- ?pos 3) Empty)
    )
 )
 =>
 (assert (CloseToWinVertical))
)

(defrule CheckCloseToWinHorizontal
  (declare (salience 500))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|4|7 ?p)
      (Board =(+ ?pos 1) Empty)
      (Board =(+ ?pos 2) ?p)
    )
    (and
      (Board ?pos&1|4|7 ?p)
      (Board =(+ ?pos 2) Empty)
      (Board =(+ ?pos 1) ?p)
    )
    (and
      (Board ?pos&3|6|9 ?p)
      (Board =(- ?pos 1) Empty)
      (Board =(- ?pos 2) ?p)
    )
    (and
      (Board ?pos&3|6|9 ?p)
      (Board =(- ?pos 2) Empty)
      (Board =(- ?pos 1) ?p)
    )
 )
 =>
 (assert (CloseToWinHorizontal))
)

(defrule CheckCloseToWinDiagonal1
  (declare (salience 500))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1 ?p)
      (Board =(+ ?pos 4) Empty)
      (Board =(+ ?pos 8) ?p)
    )
    (and
      (Board ?pos&1 ?p)
      (Board =(+ ?pos 8) Empty)
      (Board =(+ ?pos 4) ?p)
    )
    (and
      (Board ?pos&9 ?p)
      (Board =(- ?pos 4) Empty)
      (Board =(- ?pos 8) ?p)
    )
    (and
      (Board ?pos&9 ?p)
      (Board =(- ?pos 8) Empty)
      (Board =(- ?pos 4) ?p)
    )
 )
 =>
 (assert (CloseToWinDiagonal1))
)

(defrule CheckCloseToWinDiagonal2
  (declare (salience 500))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&3 ?p)
      (Board =(+ ?pos 2) Empty)
      (Board =(+ ?pos 4) ?p)
    )
    (and
      (Board ?pos&3 ?p)
      (Board =(+ ?pos 4) Empty)
      (Board =(+ ?pos 2) ?p)
    )
    (and
      (Board ?pos&7 ?p)
      (Board =(- ?pos 2) Empty)
      (Board =(- ?pos 4) ?p)
    )
    (and
      (Board ?pos&7 ?p)
      (Board =(- ?pos 4) Empty)
      (Board =(- ?pos 2) ?p)
    )
 )
 =>
 (assert (CloseToWinDiagonal2))
)

(defrule CheckOpCloseToWinVertical
  (declare (salience 400))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|2|3 ?o)
      (Board =(+ ?pos 3) ?o)
      (Board =(+ ?pos 6) Empty)
    )
    (and
      (Board ?pos&1|2|3 ?o)
      (Board =(+ ?pos 6) ?o)
      (Board =(+ ?pos 3) Empty)
    )
    (and
      (Board ?pos&7|8|9 ?o)
      (Board =(- ?pos 3) ?o)
      (Board =(- ?pos 6) Empty)
    )
    (and
      (Board ?pos&7|8|9 ?o)
      (Board =(- ?pos 6) ?o)
      (Board =(- ?pos 3) Empty)
    )
 )
 =>
 (assert (OpCloseToWinVertical))
)

(defrule CheckOpCloseToWinHorizontal
  (declare (salience 400))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|4|7 ?o)
      (Board =(+ ?pos 1) Empty)
      (Board =(+ ?pos 2) ?o)
    )
    (and
      (Board ?pos&1|4|7 ?o)
      (Board =(+ ?pos 2) Empty)
      (Board =(+ ?pos 1) ?o)
    )
    (and
      (Board ?pos&3|6|9 ?o)
      (Board =(- ?pos 1) Empty)
      (Board =(- ?pos 2) ?o)
    )
    (and
      (Board ?pos&3|6|9 ?o)
      (Board =(- ?pos 2) Empty)
      (Board =(- ?pos 1) ?o)
    )
 )
 =>
 (assert (OpCloseToWinHorizontal))
)

(defrule CheckOpCloseToWinDiagonal1
  (declare (salience 400))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1 ?o)
      (Board =(+ ?pos 4) Empty)
      (Board =(+ ?pos 8) ?o)
    )
    (and
      (Board ?pos&1 ?o)
      (Board =(+ ?pos 8) Empty)
      (Board =(+ ?pos 4) ?o)
    )
    (and
      (Board ?pos&9 ?o)
      (Board =(- ?pos 4) Empty)
      (Board =(- ?pos 8) ?o)
    )
    (and
      (Board ?pos&9 ?o)
      (Board =(- ?pos 8) Empty)
      (Board =(- ?pos 4) ?o)
    )
 )
 =>
 (assert (OpCloseToWinDiagonal1))
)

(defrule CheckOpCloseToWinDiagonal2
  (declare (salience 400))
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&3 ?o)
      (Board =(+ ?pos 2) Empty)
      (Board =(+ ?pos 4) ?o)
    )
    (and
      (Board ?pos&3 ?o)
      (Board =(+ ?pos 4) Empty)
      (Board =(+ ?pos 2) ?o)
    )
    (and
      (Board ?pos&7 ?o)
      (Board =(- ?pos 2) Empty)
      (Board =(- ?pos 4) ?o)
    )
    (and
      (Board ?pos&7 ?o)
      (Board =(- ?pos 4) Empty)
      (Board =(- ?pos 2) ?o)
    )
 )
 =>
 (assert (OpCloseToWinDiagonal2))
)

(defrule CloseToWinVertical
  (declare (salience 999))
  (CloseToWinVertical)
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|2|3 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 3) Empty)
      (Board =(+ ?pos 6) ?p)
    )
    (and
      (Board ?pos&1|2|3 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 6) Empty)
      (Board =(+ ?pos 3) ?p)
    )
    (and
      (Board ?pos&7|8|9 ?p)
      ?state <- (Board ?newPos&=(- ?pos 3) Empty)
      (Board =(- ?pos 6) ?p)
    )
    (and
      (Board ?pos&7|8|9 ?p)
      ?state <- (Board ?newPos&=(- ?pos 6) Empty)
      (Board =(- ?pos 3) ?p)
    )
 )
 =>
 (retract ?state)
 (assert (Board ?newPos ?p))
 (println ?p "->" ?newPos)
 (assert (PlayerWins))
 (println "Player Wins!")
 (halt)
)

(defrule CloseToWinHorizontal
  (declare (salience 999))
  (CloseToWinHorizontal)
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|4|7 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 1) Empty)
      (Board =(+ ?pos 2) ?p)
    )
    (and
      (Board ?pos&1|4|7 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 2) Empty)
      (Board =(+ ?pos 1) ?p)
    )
    (and
      (Board ?pos&3|6|9 ?p)
      ?state <- (Board ?newPos&=(- ?pos 1) Empty)
      (Board =(- ?pos 2) ?p)
    )
    (and
      (Board ?pos&3|6|9 ?p)
      ?state <- (Board ?newPos&=(- ?pos 2) Empty)
      (Board =(- ?pos 1) ?p)
    )
 )
 =>
 (retract ?state)
 (assert (Board ?newPos ?p))
 (println ?p "->" ?newPos)
 (assert (PlayerWins))
 (println "Player Wins!")
 (halt)
)

(defrule CloseToWinDiagonal1
  (declare (salience 999))
  (CloseToWinDiagonal1)
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 4) Empty)
      (Board =(+ ?pos 8) ?p)
    )
    (and
      (Board ?pos&1 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 8) Empty)
      (Board =(+ ?pos 4) ?p)
    )
    (and
      (Board ?pos&9 ?p)
      ?state <- (Board ?newPos&=(- ?pos 4) Empty)
      (Board =(- ?pos 8) ?p)
    )
    (and
      (Board ?pos&9 ?p)
      ?state <- (Board ?newPos&=(- ?pos 8) Empty)
      (Board =(- ?pos 4) ?p)
    )
 )
 =>
 (retract ?state)
 (assert (Board ?newPos ?p))
 (println ?p "->" ?newPos)
 (assert (PlayerWins))
 (println "Player Wins!")
 (halt)
)

(defrule CloseToWinDiagonal2
  (declare (salience 999))
  (CloseToWinDiagonal2)
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&3 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 2) Empty)
      (Board =(+ ?pos 4) ?p)
    )
    (and
      (Board ?pos&3 ?p)
      ?state <- (Board ?newPos&=(+ ?pos 4) Empty)
      (Board =(+ ?pos 2) ?p)
    )
    (and
      (Board ?pos&7 ?p)
      ?state <- (Board ?newPos&=(- ?pos 2) Empty)
      (Board =(- ?pos 4) ?p)
    )
    (and
      (Board ?pos&7 ?p)
      ?state <- (Board ?newPos&=(- ?pos 4) Empty)
      (Board =(- ?pos 2) ?p)
    )
 )
 =>
 (retract ?state)
 (assert (Board ?newPos ?p))
 (println ?p "->" ?newPos)
 (assert (PlayerWins))
 (println "Player Wins!")
 (halt)
)

(defrule OpCloseToWinVertical
  (declare (salience 899))
  ?b <- (OpCloseToWinVertical)
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|2|3 ?o)
      ?state <- (Board ?newPos&=(+ ?pos 3) Empty)
      (Board =(+ ?pos 6) ?o)
    )
    (and
      (Board ?pos&1|2|3 ?o)
      ?state <- (Board ?newPos&=(+ ?pos 6) Empty)
      (Board =(+ ?pos 3) ?o)
    )
    (and
      (Board ?pos&7|8|9 ?o)
      ?state <- (Board ?newPos&=(- ?pos 3) Empty)
      (Board =(- ?pos 6) ?o)
    )
    (and
      (Board ?pos&7|8|9 ?o)
      ?state <- (Board ?newPos&=(- ?pos 6) Empty)
      (Board =(- ?pos 3) ?o)
    )
 )
 =>
 (retract ?state)
 (assert (Board ?newPos ?p))
 (retract ?b)
 (println ?p "->" ?newPos)
 (halt)
)

(defrule OpCloseToWinHorizontal
  (declare (salience 899))
  ?b <- (OpCloseToWinHorizontal)
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1|4|7 ?o)
      ?state <- (Board ?newPos&=(+ ?pos 1) Empty)
      (Board =(+ ?pos 2) ?o)
    )
    (and
      (Board ?pos&1|4|7 ?o)
      ?state <- (Board ?newPos&=(+ ?pos 2) Empty)
      (Board =(+ ?pos 1) ?o)
    )
    (and
      (Board ?pos&3|6|9 ?o)
      ?state <- (Board ?newPos&=(- ?pos 1) Empty)
      (Board =(- ?pos 2) ?o)
    )
    (and
      (Board ?pos&3|6|9 ?o)
      ?state <- (Board ?newPos&=(- ?pos 2) Empty)
      (Board =(- ?pos 1) ?o)
    )
 )
 =>
 (retract ?state)
 (assert (Board ?newPos ?p))
 (retract ?b)
 (println ?p "->" ?newPos)
 (halt)
)

(defrule OpCloseToWinDiagonal1
  (declare (salience 899))
  ?b <- (OpCloseToWinDiagonal1)
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&1 ?o)
      ?state <- (Board ?newPos&=(+ ?pos 4) Empty)
      (Board =(+ ?pos 8) ?o)
    )
    (and
      (Board ?pos&1 ?o)
      ?state <- (Board ?newPos&=(+ ?pos 8) Empty)
      (Board =(+ ?pos 4) ?o)
    )
    (and
      (Board ?pos&9 ?o)
      ?state <- (Board ?newPos&=(- ?pos 4) Empty)
      (Board =(- ?pos 8) ?o)
    )
    (and
      (Board ?pos&9 ?o)
      ?state <- (Board ?newPos&=(- ?pos 8) Empty)
      (Board =(- ?pos 4) ?o)
    )
 )
 =>
 (retract ?state)
 (assert (Board ?newPos ?p))
 (retract ?b)
 (println ?p "->" ?newPos)
 (halt)
)

(defrule OpCloseToWinDiagonal2
  (declare (salience 899))
  ?b <- (OpCloseToWinDiagonal2)
  (MakeMove ?n ?p vs ?o)
  (or
    (and
      (Board ?pos&3 ?o)
      ?state <- (Board ?newPos&=(+ ?pos 2) Empty)
      (Board =(+ ?pos 4) ?o)
    )
    (and
      (Board ?pos&3 ?o)
      ?state <- (Board ?newPos&=(+ ?pos 4) Empty)
      (Board =(+ ?pos 2) ?o)
    )
    (and
      (Board ?pos&7 ?o)
      ?state <- (Board ?newPos&=(- ?pos 2) Empty)
      (Board =(- ?pos 4) ?o)
    )
    (and
      (Board ?pos&7 ?o)
      ?state <- (Board ?newPos&=(- ?pos 4) Empty)
      (Board =(- ?pos 2) ?o)
    )
 )
 =>
 (retract ?state)
 (assert (Board ?newPos ?p))
 (retract ?b)
 (println ?p "->" ?newPos)
 (halt)
)
