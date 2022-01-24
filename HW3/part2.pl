
% knowledge base

flight(istanbul,izmir,2). % fact: Istanbul and Izmir has a flight with cost 2.
flight(istanbul,ankara,1).
flight(istanbul,rize,4).
flight(rize,ankara,5).

% reverse order
flight(izmir,istanbul,2). % fact: Istanbul and Izmir has a flight with cost 2.
flight(ankara,istanbul,1).
flight(rize,istanbul,4).
flight(ankara,rize,5).



flight(ankara,van,4).
flight(ankara,izmir,6).
flight(ankara,diyarbakir,8).

% reverse order 2 

flight(van,ankara,4).
flight(izmir,ankara,6).
flight(diyarbakir,ankara,8).


flight(van,gaziantep,3).

flight(diyarbakir,antalya,4).

flight(izmir,antalya,2).

flight(antalya,erzincan,3).

flight(canakkale,erzincan,6).

% reverse order 3 

flight(gaziantep,van,3).

flight(antalya,diyarbakir,4).

flight(antalya,izmir,2).

flight(erzincan,antalya,3).

flight(erzincan,canakkale,6).
% flight(X,Y,C) :- flight(Y,X,C).

notequal(X,Y) :- \+(X = Y).




% \+ (X = Y)
% rules
route(X,Y,C) :- 
  X \== Y,
  flight(X,Y,C).

% route(X,Y,C) :- \+ (X = Y),flight(X,Y,C). % a predicate indicating there exist a route between
% route(X,Y,C) :- flight(X,Z,A),X \== Z, route(Z,Y,B),Z \== Y, X \== Y,C is A+B .
% route(X,Y,C) :- \+ (X = Y),route(X,Z,B).
% X and Y if there is flight between X and Y with cost
% C.