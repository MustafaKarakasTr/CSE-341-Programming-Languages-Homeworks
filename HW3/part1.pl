% room(name,id,capacity)
roomid(z23,1).
roomid(z10,2).
roomid(z11,3).

roomcapacity(z23,110).
roomcapacity(z10,100).
roomcapacity(z11,50).

% roomoccupancy(class, hour,courseId)
roomoccupancy(z23,14,341).
roomoccupancy(z10,9,341).

roomoccupancy(z23,15,222).


roomoccupancy(z11,8,101).


roomequ(z23,projector).
roomequ(z23,smartboard).

roomequ(z10,smartboard).
roomequ(z10,computer).
roomequ(z10,projector).


roomequ(z11,smartboard).
roomequ(z11,access_hc).
roomequ(z11,computer).
roomequ(z11,projector).

% course = id,instructor,capacity,hours,roomInformation,students,equipment needs, if special needs student enrolled, room should be choosen accordingly 
% course(id,instructor,capacity)
 
course(341,yakup_genc,100).
course(222,erdogan_sevilgen,80).
course(101,mehmet_gokturk,40).

courseneed(101,projector).

courseneed(341,smartboard).
% courseneed(341,access_hc).
%courseneed(341,computer).

% courseneed(222,computer).

% instructor = id,courses, preferences for rooms with a projector or smartboard 
instructor(1,yakup_genc).
instructor(10,erdogan_sevilgen).
instructor(11,mehmet_gokturk).


preferences(yakup_genc,projector).
preferences(yakup_genc,computer).


preferences(erdogan_sevilgen,projector).
preferences(erdogan_sevilgen,smartboard).

preferences(mehmet_gokturk,projector).

% student = id,courses, is handicapped 
student(mustafa,14,false).
student(ahmet,10,false).
student(ugur,11,false).
student(marx,4,true).


studentscourse(mustafa,341).
studentscourse(ahmet,222).

studentscourse(ugur,222).
studentscourse(ugur,341).

studentscourse(marx,101). % because z11 has access_hc, z11 can be assigned for 101

% 1) Check whether there is any scheduling conflict.

scheduling_conflict() :- 
    roomoccupancy(Room1,Time1,Course1),
    roomoccupancy(Room2,Time2,Course2),
    Course1 \==  Course2,
    Time1 == Time2,
    Room1 == Room2,
    format('Room: ~w Hour:~w Course ~w ~nRoom: ~w Hour:~w Course ~w ~n Conflict exist~n', [Room1, Time1,Course1,Room2, Time2,Course2]).
    % format('There is scheduling conflict~n').

% 2) Check which room can be assigned to a given class.

roomsCanBeAssignedToClass(ClassId) :-
    %  course(341,yakup_genc,200).
    % course(ClassId,Instructor,Coursecapacity).
    
    course(ClassId,Instructor,Coursecapacity),
    
    roomcapacity(RoomName,RoomCapacity),

    RoomCapacity >= Coursecapacity,
    % course need check
    allNeedsSatisfied(ClassId,RoomName),
    /*
    courseneed(ClassId,NeededByCourse),
    format('~w Needed By ~w~n', [NeededByCourse,ClassId]),
    roomequ(RoomName,NeededByCourse),
    */

    % instructor needs check

    allNeedsOfInstructorSatisfied(Instructor,RoomName),


    checkForHandicappedStudent(RoomName,ClassId),
    /*
    preferences(Instructor,InstructorNeeds),
    format('Instructor: ~w needs ~w ~n', [Instructor, InstructorNeeds]),
    roomequ(RoomName,InstructorNeeds),
    */
    format('~w can be assigned to Course ~w~n', [RoomName, ClassId]).

thereIsNoHandicappedStudent([Student | Rest]):-
    student(Student,_,false), % check if is there any studentd handicapped
    (proper_length(Rest,0);thereIsNoHandicappedStudent(Rest)).

checkForHandicappedStudent(RoomName,ClassId):-
    findall(StudentOfClass,studentscourse(StudentOfClass,ClassId),Students),
    (thereIsNoHandicappedStudent(Students) ; roomequ(RoomName,access_hc)).

% 3) Check which room can be assigned to which classes.
whichRoomsCanBeAssignedToWhichClasses():-
    course(Course,_,_),
    roomsCanBeAssignedToClass(Course).

ifStudentHandicappedRoomIsEquipped(Room) :-
    roomequ(Room,access_hc).



% 4) Check whether a student can be enrolled to a given class 
checkWhetherStudentCanBeEnrolledToClass(StudentName,ClassId):-


    student(StudentName,_,Handicapped),
    roomoccupancy(Room,_,ClassId),
    (Handicapped == false ; ifStudentHandicappedRoomIsEquipped(Room)),
    format('Room: ~w ~w can be enrolled to class ~w~n', [Room,StudentName, ClassId]),
    3 + 1 is 4.

% 5) Check which classes a student can be assigned.
classesStudentCanBeAssigned(StudentName) :-
    student(StudentName,_,Handicapped),
    roomoccupancy(Room,_,ClassId),
    (Handicapped == false ; ifStudentHandicappedRoomIsEquipped(Room)),

    format('Room: ~w ~w can be assigned to Course ~w~n', [Room,StudentName, ClassId]).

allNeedsSatisfied(ClassId,RoomName):-
    % find course needs
    findall(NeededByCourse,courseneed(ClassId,NeededByCourse),NeedList),

    % find what class has
    findall(ClassProvides,roomequ(RoomName,ClassProvides),Provided),
    (proper_length(NeedList,0); (doesClassHaveAllOfThem(Provided,NeedList); 3 + 1 is 4)).

doesClassHaveAllOfThem(Provided,[Need | Rest]):-

    member(Need, Provided),
    (proper_length(Rest,0);doesClassHaveAllOfThem(Provided,Rest)).
    
allNeedsOfInstructorSatisfied(Instructor,RoomName):-
    % find instructor needs
    findall(NeededByInstructor,preferences(Instructor,NeededByInstructor),NeedList),
    % find what class has
    findall(ClassProvides,roomequ(RoomName,ClassProvides),Provided),
    (proper_length(NeedList,0); (doesClassHaveAllOfThem(Provided,NeedList); 3 + 1 is 4)).