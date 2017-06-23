# SlidingSquaresLoader

![demo](demo.gif)

***

This is reconstruction of the custom UI control made for exercise (it's a proof-of-concept, not at all production-ready)

Notes:
Project basically consists of a logic part (functional core), and UI, which 
is kind of "interpreter" (imperative shell).

[Logic part](https://github.com/trolmark/SlidingSquaresLoader/blob/master/SnakeProgressIndicator/Logic.swift) have internal immutable state, which is presentation of current state of the control ( move, current positions of items).
[UI part](https://github.com/trolmark/SlidingSquaresLoader/blob/master/SnakeProgressIndicator/UIControl.swift) get internal logic state and "map" it on UI objects.




