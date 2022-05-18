globals [
  happiness-persons
  love-persons
  anger-persons
  fear-persons
  sadness-persons

  happiness-contagion
  love-contagion
  anger-contagion
  fear-contagion
  sadness-contagion

  mood-change-happiness
  mood-change-love
  mood-change-anger
  mood-change-fear
  mood-change-sadness

  mood-change-total
  mood-change-prob-total

  mood-change-happ-prob
  mood-change-love-prob
  mood-change-anger-prob
  mood-change-fear-prob
  mood-change-sadness-prob

  norm-happ
  norm-love
  norm-anger
  norm-fear
  norm-sadness

  numb-persons-room
]

turtles-own [

  ecs-happiness
  ecs-love
  ecs-anger
  ecs-fear
  ecs-sadness

  happiness
  love
  anger
  fear
  sadness

  emotional-status
  max-em
  max-em-value

  sum-emotion
]

to setup
  clear-all
  import-pcolors "stanza_4.png"
  setup-emotion
  reset-ticks
end

to setup-emotion
  create-turtles group-size [

    ;setxy random-ycor 3
    ;set shape "default"
    ;set size 1.5

    set ecs-happiness random-float (4.6 - 3.4) + 3.4
    set ecs-love random-float (4.7 - 3.3) + 3.3
    set ecs-anger random-float (4.2 - 2.8) + 2.8
    set ecs-fear random-float (3.9 - 2.3) + 2.3
    set ecs-sadness random-float (4.2 - 2.6) + 2.6

    set emotional-status one-of [ "happiness" "love" "anger" "fear" "sadness"]
    let increment group-size / 5
    ifelse numb-persons-room < increment [
      setxy (-28 + random 12) 14
    ][
      ifelse numb-persons-room < ( increment * 2 ) [
        setxy (-28 + random 12) -7
      ][
        ifelse numb-persons-room < ( increment * 3) [
          setxy (-4 + random 12) -9
        ][
          ifelse numb-persons-room < ( increment * 4 ) [
            setxy (10 + random 12) 11
          ][
            if numb-persons-room < ( increment * 5 ) [
              setxy (0 + random 12) 0
            ]
          ]
        ]
      ]
    ]
    set numb-persons-room numb-persons-room + 1
    if emotional-status = "happiness" [
      ;setxy (-28 + random 12) 14
      set shape "default"
      set size 1.5
      set happiness-persons happiness-persons + 1
      set happiness random-float 2
      set love happiness / 4 * (-1)
      set anger happiness / 4 * (-1)
      set fear happiness / 4 * (-1)
      set sadness happiness / 4 * (-1)

      set max-em "happiness"
      set max-em-value happiness

      set sum-emotion (happiness + love + anger + fear + sadness)

      set color green
      ;set label "happiness"
      set label-color black
    ]
    if emotional-status = "love" [
      ;setxy (-28 + random 12) -7
      set shape "default"
      set size 1.5
      set love-persons love-persons + 1
      set love random-float 2
      set happiness love / 4 * (-1)
      set anger love / 4 * (-1)
      set fear love / 4 * (-1)
      set sadness love / 4 * (-1)

      set max-em "love"
      set max-em-value love
      set sum-emotion (happiness + love + anger + fear + sadness)

      set color red
      ;set label "love"
      set label-color black
    ]
    if emotional-status = "anger" [
      ;setxy (-4 + random 12) -9
      set shape "default"
      set size 1.5
      set anger-persons anger-persons + 1
      set anger random-float 2
      set happiness anger / 4 * (-1)
      set love anger / 4 * (-1)
      set fear anger / 4 * (-1)
      set sadness anger / 4 * (-1)

      set max-em "anger"
      set max-em-value anger
      set sum-emotion (happiness + love + anger + fear + sadness)

      set color violet
      ;set label "anger"
      set label-color black
    ]
    if emotional-status = "fear" [
      ;setxy (10 + random 12) 11
      set shape "default"
      set size 1.5
      set fear-persons fear-persons + 1
      set fear random-float 2
      set happiness fear / 4 * (-1)
      set love fear / 4 * (-1)
      set anger fear / 4 * (-1)
      set sadness fear / 4 * (-1)

      set max-em "fear"
      set max-em-value fear
      set sum-emotion (happiness + love + anger + fear + sadness)

      set color blue
      ;set label "fear"
      set label-color black
    ]
    if emotional-status = "sadness" [
      ;setxy (0 + random 12) 0
      set shape "default"
      set size 1.5
      set sadness-persons sadness-persons + 1
      set sadness random-float 2
      set happiness sadness / 4 * (-1)
      set love sadness / 4 * (-1)
      set anger sadness / 4 * (-1)
      set fear sadness / 4 * (-1)

      set max-em "sadness"
      set max-em-value sadness
      set sum-emotion (happiness + love + anger + fear + sadness)

      set color yellow
      ;set label "sadness"
      set label-color black
    ]
    take-max-emotion
  ]
end

to go
  ask turtles [
    set norm-happ 0
    set norm-love 0
    set norm-anger 0
    set norm-fear 0
    set norm-sadness 0
    move
    em-status-indol
    emotion-contagion
    take-max-emotion
    set happiness-persons count turtles with [color = green]
    set love-persons count turtles with [color = red]
    set anger-persons count turtles with [color = violet]
    set fear-persons count turtles with [color = blue]
    set sadness-persons count turtles with [color = yellow]
    ;
    ask turtles with [ color = green][
      set norm-happ norm-happ + happiness
    ]
    ask turtles with [ color = red][
      set norm-love norm-love + love
    ]
    ask turtles with [ color = violet][
      set norm-anger norm-anger + anger
    ]
    ask turtles with [ color = blue][
      set norm-fear norm-fear + fear
    ]
    ask turtles with [ color = yellow][
      set norm-sadness norm-sadness + sadness
    ]
    ;
  ]
  set mood-change-total ( mood-change-happiness + mood-change-love + mood-change-anger + mood-change-fear + mood-change-sadness)
  ;set total-contagion
  if happiness-contagion != 0 [ set mood-change-happ-prob ( mood-change-happiness / happiness-contagion ) ]
  if love-contagion != 0 [  set mood-change-love-prob ( mood-change-love / love-contagion ) ]
  if anger-contagion != 0 [ set mood-change-anger-prob ( mood-change-anger / anger-contagion ) ]
  if fear-contagion != 0 [ set mood-change-fear-prob ( mood-change-fear / fear-contagion ) ]
  if sadness-contagion != 0 [ set mood-change-sadness-prob ( mood-change-sadness / sadness-contagion ) ]
 tick
end

to em-status-indol
  if count turtles-on neighbors = 0 [
    if emotional-status = "happiness" [
      ifelse happiness < (5 - status-value) + 0.01 [
        set happiness happiness + status-value
        set love love - (status-value / 4)
        set anger anger - (status-value / 4)
        set fear fear - (status-value / 4)
        set sadness sadness - (status-value / 4)
      ]
      [ let diff (5 - happiness)
        set happiness 5
        set love love - (diff / 4)
        set anger anger - (diff / 4)
        set fear fear - (diff / 4)
        set sadness sadness - (diff / 4)
      ]
    ]
    if emotional-status = "love" [
      ifelse love < (5 - status-value) + 0.01 [
        set happiness happiness - (status-value / 4)
        set love love + status-value
        set anger anger - (status-value / 4)
        set fear fear - (status-value / 4)
        set sadness sadness - (status-value / 4)
      ]
      [ let diff (5 - love)
        set love 5
        set happiness happiness - (diff / 4)
        set anger anger - (diff / 4)
        set fear fear - (diff / 4)
        set sadness sadness - (diff / 4)
      ]
    ]
    if emotional-status = "anger" [
      ifelse anger < (5 - status-value) + 0.01 [
        set happiness happiness - (status-value / 4)
        set love love - (status-value / 4)
        set anger anger + status-value
        set fear fear - (status-value / 4)
        set sadness sadness - (status-value / 4)
      ]
      [ let diff (5 - anger)
        set anger 5
        set love love - (diff / 4)
        set happiness happiness - (diff / 4)
        set fear fear - (diff / 4)
        set sadness sadness - (diff / 4)
      ]
    ]
    if emotional-status = "fear" [
      ifelse fear < (5 - status-value) + 0.01 [
        set happiness happiness - (status-value / 4)
        set love love - (status-value / 4)
        set anger anger - (status-value / 4)
        set fear fear + status-value
        set sadness sadness - (status-value / 4)
      ]
      [ let diff (5 - fear)
        set fear 5
        set love love - (diff / 4)
        set anger anger - (diff / 4)
        set happiness happiness - (diff / 4)
        set sadness sadness - (diff / 4)
      ]
    ]
    if emotional-status = "sadness" [
      ifelse sadness < (5 - status-value) + 0.01 [
        set happiness happiness - (status-value / 4)
        set love love - (status-value / 4)
        set anger anger - (status-value / 4)
        set fear fear - (status-value / 4)
        set sadness sadness + status-value
      ]
      [ let diff (5 - sadness)
        set sadness 5
        set love love - (diff / 4)
        set anger anger - (diff / 4)
        set fear fear - (diff / 4)
        set happiness happiness - (diff / 4)
      ]
    ]
  ]
end

to emotion-contagion
  if color = green [
    let happ_cont 0
    ifelse energy [ set happ_cont (( happiness * neutral-energy ) / 4) ]
    [ set happ_cont ( happiness / 4) ]
    let nearby-persons (turtles-on neighbors)
    if nearby-persons != nobody [
      ask nearby-persons [
        if random-float 4.6 < ecs-happiness [
          ifelse happiness + happ_cont < 5 [
            set happiness happiness + happ_cont
            set love love - ( happ_cont / 4 )
            set anger anger - ( happ_cont / 4 )
            set fear fear - ( happ_cont / 4 )
            set sadness sadness - (happ_cont / 4 )
          ]
          [ let diff_happ ( 5 - happiness )
            set happiness 5
            set love love - ( diff_happ / 4 )
            set anger anger - ( diff_happ / 4 )
            set fear fear - ( diff_happ / 4 )
            set sadness sadness - ( diff_happ / 4 )
          ]
          set happiness-contagion happiness-contagion + 1
        ]
      ]
    ]
  ]
  if color = red [
    let love_cont 0
    ifelse energy [ set love_cont (( love * high-energy ) / 4) ]
    [ set love_cont ( love / 4) ]
    let nearby-persons (turtles-on neighbors)
    if nearby-persons != nobody [
      ask nearby-persons [
        if random-float 4.7 < ecs-love [
          ifelse love + love_cont < 5 [
            set love love + love_cont
            set happiness happiness - ( love_cont / 4 )
            set anger anger - ( love_cont / 4 )
            set fear fear - ( love_cont / 4 )
            set sadness sadness - ( love_cont / 4 )
          ]
          [ let diff_love ( 5 - love )
            set love 5
            set happiness happiness - ( diff_love / 4 )
            set anger anger - ( diff_love / 4 )
            set fear fear - ( diff_love / 4 )
            set sadness sadness - ( diff_love / 4 )
          ]
          set love-contagion love-contagion + 1
        ]
      ]
    ]
  ]
  if color = violet [
    let anger_cont 0
    ifelse energy [ set anger_cont (( anger * high-energy ) / 4) ]
    [ set anger_cont ( anger / 4) ]
    let nearby-persons (turtles-on neighbors)
    if nearby-persons != nobody [
      ask nearby-persons [
        if random-float 4.2 < ecs-anger [
          ifelse anger + anger_cont < 5 [
            set anger anger + anger_cont
            set happiness happiness - ( anger_cont / 4 )
            set love love - ( anger_cont / 4 )
            set fear fear - ( anger_cont / 4 )
            set sadness sadness - ( anger_cont / 4 )
          ]
          [ let diff_anger ( 5 - anger )
            set anger 5
            set happiness happiness - ( diff_anger / 4 )
            set love love - ( diff_anger / 4 )
            set fear fear - ( diff_anger / 4 )
            set sadness sadness - ( diff_anger / 4 )
          ]
          set anger-contagion anger-contagion + 1
        ]
      ]
    ]
  ]
  if color = blue [
    let fear_cont 0
    ifelse energy [ set fear_cont (( fear * high-energy ) / 4) ]
    [ set fear_cont ( fear / 4) ]
    let nearby-persons (turtles-on neighbors)
    if nearby-persons != nobody [
      ask nearby-persons [
        if random-float 3.9 < ecs-fear [
          ifelse fear + fear_cont < 5 [
            set fear fear + fear_cont
            set happiness happiness - ( fear_cont / 4 )
            set love love - ( fear_cont / 4 )
            set anger anger - ( fear_cont / 4 )
            set sadness sadness - ( fear_cont / 4 )
          ]
          [ let diff_fear ( 5 - fear )
            set fear 5
            set happiness happiness - ( diff_fear / 4 )
            set love love - ( diff_fear / 4 )
            set fear fear - ( diff_fear / 4 )
            set sadness sadness - ( diff_fear / 4 )
          ]
          set fear-contagion fear-contagion + 1
        ]
      ]
    ]
  ]
  if color = yellow [
    let sadness_cont 0
    ifelse energy [ set sadness_cont (( sadness * low-energy ) / 4) ]
    [ set sadness_cont ( sadness / 4) ]
    let nearby-persons (turtles-on neighbors)
    if nearby-persons != nobody [
      ask nearby-persons [
        if random-float 4.2 < ecs-sadness [
          ifelse sadness + sadness_cont < 5 [
            set sadness sadness + sadness_cont
            set happiness happiness - ( sadness_cont / 4 )
            set love love - ( sadness_cont / 4 )
            set anger anger - ( sadness_cont / 4 )
            set fear fear - ( sadness_cont / 4 )
          ]
          [ let diff_sad ( 5 - sadness )
            set sadness 5
            set happiness happiness - ( diff_sad / 4 )
            set love love - ( diff_sad / 4 )
            set fear fear - ( diff_sad / 4 )
            set anger anger - ( diff_sad / 4 )
          ]
          set sadness-contagion sadness-contagion + 1
        ]
      ]
    ]
  ]
end

to take-max-emotion
  let max_em_old max-em
  set max-em "happiness"
  set max-em-value happiness
  set color green
  if happiness < love [
    set max-em "love"
    set max-em-value love
    set color red
  ]
  if max-em-value < anger [
    set max-em "anger"
    set max-em-value anger
    set color violet
  ]
  if max-em-value < fear [
    set max-em "fear"
    set max-em-value fear
    set color blue
  ]
  if max-em-value < sadness [
    set max-em "sadness"
    set max-em-value sadness
    set color yellow
  ]
  set sum-emotion (happiness + love + anger + fear + sadness)
  ;set label max-em

  if max-em != max_em_old [
    if max-em = "happiness" [ set mood-change-happiness mood-change-happiness + 1 ]
    if max-em = "love" [ set mood-change-love mood-change-love + 1 ]
    if max-em = "anger" [ set mood-change-anger mood-change-anger + 1 ]
    if max-em = "fear" [ set mood-change-fear mood-change-fear + 1 ]
    if max-em = "sadness" [ set mood-change-sadness mood-change-sadness + 1 ]
  ]
end

to move
  let move-prob 70

  ifelse count neighbors with [ pcolor = 14.9 ] > 0 [
    right 180
    fd 1
  ]
  [
    ifelse count neighbors with [ pcolor = black ] > 0 [
    right 180
    fd 1
  ]
  [
    left random 50
    right random 50
    if random 100 < move-prob [ fd 1 ]
  ]
  ]

end


to open
  ;happiness room
  ask patch -27 8 [ set pcolor white ]
  ask patch -26 8 [ set pcolor white ]
  ask patch -25 8 [ set pcolor white ]
  ask patch -24 8 [ set pcolor white ]

  ask patch -12 12 [ set pcolor white ]
  ask patch -12 13 [ set pcolor white ]
  ask patch -12 14 [ set pcolor white ]

  ;love room
  ask patch -30 1 [ set pcolor white ]
  ask patch -29 1 [ set pcolor white ]
  ask patch -28 1 [ set pcolor white ]
  ask patch -27 1 [ set pcolor white ]

  ask patch -12 -15 [ set pcolor white ]
  ask patch -12 -16 [ set pcolor white ]
  ask patch -12 -17 [ set pcolor white ]

  ;fear room
  ask patch 2 14 [ set pcolor white ]
  ask patch 2 15 [ set pcolor white ]
  ask patch 2 16 [ set pcolor white ]
  ask patch 2 17 [ set pcolor white ]

  ask patch 26 8 [ set pcolor white ]
  ask patch 27 8 [ set pcolor white ]
  ask patch 28 8 [ set pcolor white ]
  ask patch 29 8 [ set pcolor white ]
  ask patch 30 8 [ set pcolor white ]

  ;anger room
  ask patch 0 -4 [ set pcolor white ]
  ask patch -1 -4 [ set pcolor white ]
  ask patch -2 -4 [ set pcolor white ]
  ask patch -3 -4 [ set pcolor white ]
  ask patch -4 -4 [ set pcolor white ]

  ask patch 23 -7 [ set pcolor white ]
  ask patch 22 -7 [ set pcolor white ]
  ask patch 21 -7 [ set pcolor white ]
  ask patch 20 -7 [ set pcolor white ]

  ask patch 19 -14 [ set pcolor white ]
  ask patch 19 -15 [ set pcolor white ]
  ask patch 19 -16 [ set pcolor white ]
  ask patch 19 -17 [ set pcolor white ]

end


to close
  ;happiness room
  ask patch -27 8 [ set pcolor 14.9 ]
  ask patch -26 8 [ set pcolor 14.9 ]
  ask patch -25 8 [ set pcolor 14.9 ]
  ask patch -24 8 [ set pcolor 14.9 ]

  ask patch -12 12 [ set pcolor 14.9 ]
  ask patch -12 13 [ set pcolor 14.9 ]
  ask patch -12 14 [ set pcolor 14.9 ]

  ;love room
  ask patch -30 1 [ set pcolor 14.9  ]
  ask patch -29 1 [ set pcolor 14.9  ]
  ask patch -28 1 [ set pcolor 14.9  ]
  ask patch -27 1 [ set pcolor 14.9  ]

  ask patch -12 -15 [ set pcolor 14.9 ]
  ask patch -12 -16 [ set pcolor 14.9 ]
  ask patch -12 -17 [ set pcolor 14.9 ]

  ;fear room
  ask patch 2 14 [ set pcolor 14.9 ]
  ask patch 2 15 [ set pcolor 14.9 ]
  ask patch 2 16 [ set pcolor 14.9 ]
  ask patch 2 17 [ set pcolor 14.9 ]

  ask patch 26 8 [ set pcolor 14.9 ]
  ask patch 27 8 [ set pcolor 14.9 ]
  ask patch 28 8 [ set pcolor 14.9 ]
  ask patch 29 8 [ set pcolor 14.9 ]
  ask patch 30 8 [ set pcolor 14.9 ]

  ;anger room
  ask patch 0 -4 [ set pcolor 14.9 ]
  ask patch -1 -4 [ set pcolor 14.9 ]
  ask patch -2 -4 [ set pcolor 14.9 ]
  ask patch -3 -4 [ set pcolor 14.9 ]
  ask patch -4 -4 [ set pcolor 14.9 ]

  ask patch 23 -7 [ set pcolor 14.9 ]
  ask patch 22 -7 [ set pcolor 14.9 ]
  ask patch 21 -7 [ set pcolor 14.9 ]
  ask patch 20 -7 [ set pcolor 14.9 ]

  ask patch 19 -14 [ set pcolor 14.9 ]
  ask patch 19 -15 [ set pcolor 14.9 ]
  ask patch 19 -16 [ set pcolor 14.9 ]
  ask patch 19 -17 [ set pcolor 14.9 ]
end
@#$#@#$#@
GRAPHICS-WINDOW
680
275
1605
813
-1
-1
12.92
1
10
1
1
1
0
1
1
1
-35
35
-20
20
1
1
1
ticks
30.0

SLIDER
198
45
370
78
group-size
group-size
5
50
35.0
5
1
NIL
HORIZONTAL

SLIDER
23
46
195
79
low-energy
low-energy
0.0
1.5
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
23
81
195
114
neutral-energy
neutral-energy
0.0
1.5
0.4
0.1
1
NIL
HORIZONTAL

SLIDER
23
117
195
150
high-energy
high-energy
0.0
1.5
0.6
0.1
1
NIL
HORIZONTAL

BUTTON
200
118
282
151
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
288
118
370
151
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
23
154
676
274
monitor persons emotions
ticks
turtles
0.0
10.0
0.0
20.0
true
true
"" ""
PENS
"happiness" 1.0 0 -10899396 true "" "plot happiness-persons"
"love" 1.0 0 -2674135 true "" "plot love-persons"
"anger" 1.0 0 -8630108 true "" "plot anger-persons"
"fear" 1.0 0 -13345367 true "" "plot fear-persons"
"sadness" 1.0 0 -1184463 true "" "plot sadness-persons"

PLOT
25
612
674
810
person monitoring
ticks
turtle 10
0.0
10.0
-7.0
7.0
true
true
"" ""
PENS
"happiness" 1.0 0 -10899396 true "" "ask turtle 4 [ plot happiness ]"
"love" 1.0 0 -2674135 true "" "ask turtle 4 [ plot love ]"
"anger" 1.0 0 -8630108 true "" "ask turtle 4 [ plot anger ]"
"fear" 1.0 0 -13345367 true "" "ask turtle 4 [ plot fear ]"
"sadness" 1.0 0 -1184463 true "" "ask turtle 4 [ plot sadness ]"

SWITCH
23
10
195
43
energy
energy
0
1
-1000

PLOT
24
424
674
610
emotions contagion
ticks
number contagious
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"happiness" 1.0 2 -10899396 true "" "plot happiness-contagion"
"love" 1.0 2 -2674135 true "" "plot love-contagion"
"anger" 1.0 2 -8630108 true "" "plot anger-contagion"
"fear" 1.0 2 -13345367 true "" "plot fear-contagion"
"sadness" 1.0 2 -1184463 true "" "plot sadness-contagion"

SLIDER
198
11
370
44
status-value
status-value
0
0.4
0.01
0.01
1
NIL
HORIZONTAL

PLOT
24
275
675
422
mood changes
ticks
mood changes
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"happiness" 1.0 0 -10899396 true "" "plot mood-change-happiness"
"love" 1.0 0 -2674135 true "" "plot mood-change-love"
"anger" 1.0 0 -8630108 true "" "plot mood-change-anger"
"fear" 1.0 0 -13345367 true "" "plot mood-change-fear"
"sadness" 1.0 0 -1184463 true "" "plot mood-change-sadness"

BUTTON
200
82
283
115
OPEN
open
NIL
1
T
PATCH
NIL
NIL
NIL
NIL
1

BUTTON
286
82
370
115
CLOSE
close
NIL
1
T
PATCH
NIL
NIL
NIL
NIL
1

MONITOR
371
11
520
56
happiness
mood-change-happ-prob
17
1
11

MONITOR
372
57
520
102
love
mood-change-love-prob
17
1
11

MONITOR
373
104
673
149
anger
mood-change-anger-prob
17
1
11

MONITOR
522
11
673
56
fear
mood-change-fear-prob
17
1
11

MONITOR
522
57
673
102
sadness
mood-change-sadness-prob
17
1
11

PLOT
679
10
1604
273
probability change mood
ticks
probability
0.0
5.0
0.0
0.1
true
true
"" ""
PENS
"happiness" 1.0 0 -10899396 true "" "plot mood-change-happ-prob"
"love" 1.0 0 -2674135 true "" "plot mood-change-love-prob"
"anger" 1.0 0 -8630108 true "" "plot mood-change-anger-prob"
"fear" 1.0 0 -13345367 true "" "plot mood-change-fear-prob"
"sadness" 1.0 0 -1184463 true "" "plot mood-change-sadness-prob"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
