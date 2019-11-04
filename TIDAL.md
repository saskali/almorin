# Tidal


## Reference

Summarizing notes from [TidalCycles Tutorial](https://tidalcycles.org/index.php/Tutorial).

## SuperCollider

start SuperDirt

    SuperDirt.start

find SuperDirt samples

    SuperCollider IDE select the File > Open User Support Directory menu item
    > downloaded-quarks > Dirt-Samples

feel free to make new folders and add your own sounds to it


## Atom

open tidal shell

    packages > tidalCycles > boot tidalCycles


## Creating Rhythmic Sequences

### Play a Single Sample

- Tidal provides 16 'connections' to SuperDirt synthesiser
    + named from d1 to d16

play kick drum every cycle

    d1 $ sound "bd"

- sound
    + function that takes pattern of sound samples
    + turns it into a pattern of synthesizer triggers
    + it’s patterns all the way down
    + fuctions can be applied to
        * inner pattern of sample names
        * outer pattern of synthesizer triggers
- "bd"
    + pattern that contains a single sound
- sample
    + live inside Dirt-Samples folder

pick different sample

    d1 $ sound "bd:3"

specify the sample number separately

    d1 $ sound "bd" # n "3"


### Playing More Than One Sequence

refer to patterns by name, rather than by number

```
    p "susan" $ sound "bd sd:1"
    p "gerard" $ sound "hh hh hh hh"
```


### What is a Cycle?

- main “loop” of time in Tidal
- cycle repeats forever in background
    + even when you’ve stopped samples from playing
- cycle’s duration always stays the same
    + unless you modify it with setcps
    + by default, there is one cycle per second
- it’s common to
    + stretch a pattern outside of a single loop
    + vary patterns from one loop to the next
- all of the samples inside of a pattern
    + get squashed into a single cycle


## Silence

empty pattern is defined as silence

    d1 silence

set all the connections (from d1 to d9) to be silent at once

    hush

isolate a single connection and silence all others

```
    d1 $ sound "bd"

    d2 $ sound "~ cp"

    -- run this and only the bd plays
    solo 1

    -- unsolo it and the cp plays again
    unsolo 1
```


## Patterns Within Patterns

create pattern grouping

    d1 $ sound "[bd sd sd] cp"

you can create denser sub-divisions of cycles

```
d1 $ sound "bd [sd sd]"

d1 $ sound "bd [sd sd sd]"

d1 $ sound "bd [sd sd sd sd]"

d1 $ sound "[bd bd] [sd sd sd sd]"

d1 $ sound "[bd bd bd] [sd sd]"

d1 $ sound "[bd bd bd bd] [sd]"
```

shorthand for this kind of grouping is to place a period . between groups

```
    d1 $ sound "bd bd . sd sd sd . bd sd"

    d1 $ sound "[bd bd] [sd sd sd] [bd sd]"
```


## Layering (Polyrhythms) Instead of Grouping

play bd bd bd at the same time as sd cp sd cp

```
    d1 $ sound "[bd bd bd, sd cp sd cp]"

    d1 $ sound "[bd bd bd, sd cp sd cp, arpy arpy, odx]"

    d1 $ sound "[bd bd bd, [sd sd] cp, arpy [arpy [arpy arpy] arpy arpy], odx]"
```

### Playing one step per cycle

results in sequence 'bd arpy:1 bd arpy:2 bd arpy:3'

    d1 $ sound "bd <arpy:1 arpy:2 arpy:3>"


## Pattern Repetition and Speed

### Repetition

symbol * to make a pattern repeat

    d1 $ sound "bd*2"

slow down

    d1 $ sound "bd/2"


## Modifying Sequences With Functions

- re-order sequences
- alter time
- provide conditional logic
- help compose more complex patterns

reverse a pattern

    d1 $ rev (sound "bd*2 [bd [sn sn*2 sn] sn]")

### every

- takes three parameters
    + a number
    + a function
    + a pattern to apply the function to
- number specifies how often function is applied to pattern

reverse pattern every fourth repetition

    d1 $ every 4 (rev) (sound "bd*2 [bd [sn sn*2 sn] sn]")

### Modify Speed

- use functions
    + slow
    + fast
        * also known as density
    + slow 0.25 <=> fast 4


## Applying effects with control patterns

- effects that you can apply to sounds
- control patterns
    + change volume
    + add delay or distortion
- sound itself creates a control pattern
- apply effects by combining control patterns together
    + adding # operator between them

### Effects

cps         change tempo
crush       bitcrushing
gain        changes volume, values from 0 to 1
pan         pans sound right and left, values from 0 to 1
shape       a type of amplifier, values from 0 to 1
vowel       a vowel formant filter, values include a, e, i, o, and u
speed       changes playback speed of a sample, see below

### Control values are patterns too

pattern in effect values

    d1 $ sound "bd*4" # gain "1 0.8 0.5 0.7"

control patterns follow all the same grouping rules as sound patterns

    d1 $ sound "bd*4 sn*4" # gain "[[1 0.8]*2 [0.5 0.7]]/2"

apply functions to control patterns

    d1 $ sound "bd*4" # (every 3 (rev) $ gain "1 0.8 0.5 0.7")

### Control pattern order

specify effect control before sound control

    d1 $ gain "1 0.8 0.5 0.7" # sound "bd"

- order matters
- with #
    + structure of pattern is given by pattern on the left

### Modifying control values

- # operator
    + shortcut to a longer form of operator called |>
- |> operator
    + part of a family of operators
    + means something special about combining patterns
    + used to combine patterns

use |> to combine patterns conditionally

    d1 $ every 2 (|> speed "2") $ sound "arpy*4" |> speed "1"

- perform arithmetic
    |+  |-  |*  |/


## Shorthand for numerical patterns

- when specifying patterns of single numbers
    + you can miss off the double quotes

shorthand

    d1 $ sound "arpy(3,8)" # n 2

treat patterns of numbers as simple numbers

    d1 $ sound "arpy(3,8)" # n ("0 2" * 2)

specify increasing or decreasing numbers with a range

    d1 $ n "[0 .. 7] [3 .. 1]" # sound "supergong"
    d1 $ n "[0 1 2 3 4 5 6 7] [3 2 1]" # sound "supergong"


## Sample Playback Speed (and Pitch)

- use speed to
    + change pitches
    + create a weird effect
    + match length of a sample to a specific period of the cycle time
        * but see loopAt function for an easy way of doing the latter

You can set a sample’s speed by using the speed effect with a number

    speed "1" plays a sample at its original speed
    speed "0.5" plays a sample at half of its original speed
    speed "2" plays a sample at double its original speed

    d1 $ sound "arpy" # speed "1"
    d1 $ sound "arpy" # speed "0.5"
    d1 $ sound "arpy" # speed "2"

specify a pattern for speed

    d1 $ speed "1 0.5 2 1.5" # sound "arpy"

reverse a sample by specifying negative values

    d1 $ speed "-1 -0.5 -2 -1.5" # sound "arpy"


### Play a sample at multiple speeds simultaneously

    d1 $ sound "arpy" # speed "[1, 1.5]"
    d1 $ speed "[1 0.5, 1.5 2 3 4]" # sound "arpy"

### 12-tone scale speeds

- up function
    + to change playback speed
    + shortcut effect
    + matches speeds to half steps on a 12-tone scale

chromatic scale

    d1 $ up "0 1 2 3 4 5 6 7 8 9 10 11" # sound "arpy"

run function to create an incrementing pattern of integers

    d1 $ up (run 12) # sound "arpy"


## Euclidean Sequences

distribute first number of sounds equally across second number of steps

    d1 $ sound "bd(5,8)"
    d1 $ euclid 5 8 $ sound "bd"

bonus: possible to pattern the parameters within the parenthesis
for example to alternate between 3 and 5 elements

    d1 $ sound "bd([5 3]/2,8)"

- these types of sequences use “Bjorklund’s algorithm”
- wasn’t made for music
    + but for application in nuclear physics
- very similar in structure to
    + one of the first known algorithms
    + written in Euclid’s book of elements
    + in 300 BC
- read more about this in the paper `The Euclidean Algorithm Generates Traditional Musical Rhythms` by Toussaint

```
(2,5) : A thirteenth century Persian rhythm called Khafif-e-ramal.
(3,4) : The archetypal pattern of the Cumbia from Colombia, as well as a Calypso rhythm from Trinidad.
(3,5,2) : Another thirteenth century Persian rhythm by the name of Khafif-e-ramal, as well as a Rumanian folk-dance rhythm.
(3,7) : A Ruchenitza rhythm used in a Bulgarian folk-dance.
(3,8) : The Cuban tresillo pattern.
(4,7) : Another Ruchenitza Bulgarian folk-dance rhythm.
(4,9) : The Aksak rhythm of Turkey.
(4,11) : The metric pattern used by Frank Zappa in his piece titled Outside Now.
(5,6) : Yields the York-Samai pattern, a popular Arab rhythm.
(5,7) : The Nawakhat pattern, another popular Arab rhythm.
(5,8) : The Cuban cinquillo pattern.
(5,9) : A popular Arab rhythm called Agsag-Samai.
(5,11) : The metric pattern used by Moussorgsky in Pictures at an Exhibition.
(5,12) : The Venda clapping pattern of a South African children’s song.
(5,16) : The Bossa-Nova rhythm necklace of Brazil.
(7,8) : A typical rhythm played on the Bendir (frame drum).
(7,12) : A common West African bell pattern.
(7,16,14) : A Samba rhythm necklace from Brazil.
(9,16) : A rhythm necklace used in the Central African Republic.
(11,24,14) : A rhythm necklace of the Aka Pygmies of Central Africa.
(13,24,5) : Another rhythm necklace of the Aka Pygmies of the upper Sangha.
```


## Tempo

- core unit of time
    + cycles per second
- can be set with `setcps`

setcps accepts a positive numeric value that can include a decimal

    setcps 1.5
    setcps 0.75
    setcps 10

play at 140 bpm with four beats per cycle

    setcps (140/60/4)

pattern the tempo with the cps control function

    d1 $ sound "cp(3,8)" # cps (slow 8 $ range 0.8 1.6 saw)


## The Run Function

- utility function called run
- returns pattern of integers up to a specified maximum

use run with effects to aid in automatically generating a linear pattern

    d1 $ sound "arpy*8" # up (run 8)
    d1 $ sound "arpy*8" # speed (run 8)


## (Algorithmically) Selecting Samples

- sound parameter
    + can be broken into two separate parameters
    + making it easy to select samples with a pattern
    + s: name of sample set
    + n: number of sample within that set

following patterns do exactly the same

    d1 $ sound "arpy:0 arpy:2 arpy:3"
    d1 $ n "0 2 3" # s "arpy"

    d1 $ sound $ samples "drum*4" "0 1 2 3"
    d1 $ sound "drum:0 drum:1 drum:2 drum:3"

    d1 $ n (run 4) # s "drum"
    d1 $ sound $ samples "drum*4" (run 4) -- or with samples


## Combining Types of Patterns

adding effects

    d1 $ sound "bd sn drum arpy" # pan "0 1 0.25 0.75"

    d1 $ pan "0 1 0.25" # sound "bd sn drum arpy"s

- pipe operators (|>, |+, |-, |*, |/, |>, and so on)
- allow us to combine two patterns
- remember that # is shorthand for |>
- wondering how tidal decides
    + which sound values get matched with which pan values in the above
    + for each value in the pattern on the left
    + values from the right are matched where
        * the start (or onset) of the left value
        * fall within the timespan of the value on the right
    + e.g. the second pan value of 1 starts one third into its pattern
    + the second sound value of sn
        * starts one quarter into its pattern
        * ends at the halfway point
    + because the former onset (one third) falls inside the timespan of the latter timespan (from one quarter until one half), they are matched
- possible to switch things around
- so that structure comes from the right
- by using the operators >|, *|, +|, /| and -|, instead of |>, |*, |+ and |-

for example

    d1 $ sound "drum" >|  n "0 1*2 ~ 3"


## Oscillation with Continuous Patterns

- discrete patterns
    + patterns containing events which begin and end
- continuous patterns
    + vary continually over time
    + using wave functions
        * sine
        * saw
        * triangle
        * square

example

    d1 $ sound "bd*16" # pan sine

control speed of continuous patterns with slow or density

    d1 $ sound "bd*16" # pan (slow 8 $ saw)
    d1 $ sound "bd*8 sn*8" # pan (density 1.75 $ tri)
    d1 $ sound "bd*8 sn*8" # speed (density 2 $ tri)

### Scaling Oscillation

tell oscillation functions to
    + scale themselves
    + oscillate between two values using range

    d1 $ sound "bd*8 sn*8" # speed (range 1 3 $ tri)
    d1 $ sound "bd*8 sn*8" # speed (slow 4 $ range 1 3 $ tri)

    d1 $ sound "bd*8 sn*8" # speed (range (-2) 3 $ tri)

slow low-pass filter cutoff

    d1 $ sound "hh*32" # cutoff (range 300 1000 $ slow 4 $ sine) # resonance "0.4"

NOTE: Despite the fact that these oscillator patterns produce continuous values, you still need to combine them with discrete sound patterns.


## Rests

rest, or gap of silence

    d1 $ sound "bd bd ~ bd"


## Polymeters

- produce polymeter sequences
- polymeter pattern
    + two patterns have different sequence lengths
    + but share the same pulse or tempo

use curly brace syntax to create a polymeter rhythm

    d1 $ sound "{bd hh sn cp, arpy bass2 drum notes can}"

- results in
    + five-note rhythm
    + being played at the pulse of a four-note rhythm

create odd polymeter rhythm without base rhythm

    d1 $ sound "{~ ~ ~ ~, arpy bass2 drum notes can}"

more efficient way

    d1 $ sound "{arpy bass2 drum notes can}%4"

If “polymeter” sounds a bit confusing, there’s a good explanation here: http://music.stackexchange.com/questions/10488/polymeter-vs-polyrhythm


## Shifting Time

use ~> and <~ functions to shift patterns forwards or backwards in time

    d1 $ (0.25 <~) $ sound "bd*2 cp*2 hh sn"
    d1 $ (0.25 ~>) $ sound "bd*2 cp*2 hh sn"


## Introducing Randomness

- produce random patterns of integers and decimals
- introduce randomness into patterns by removing random events

### Random Decimal Patterns

rand function to create a random value between 0 and 1

    d1 $ sound "arpy*4" # pan (rand)

### Random Integer Patterns

irand function to create a random integer up to a given maximum

    d1 $ s "arpy*8" # n (irand 30)

hairy detail
- rand and irand are actually continuous patterns
- have infinite detail
- treat them as pure information
- deterministic, stateless functions of time
- if you retriggered a pattern from the same logical time point
    + exactly the same numbers would be produced
- if you use a rand or irand in two different places
    + get same ‘random’ pattern
    + shift or slow down time a little for one of them
        * e.g. slow 0.3 rand

### Removing or “Degrading” Pattern events

shorthand ? symbol to give event 50/50 chance of happening or not

    d1 $ sound "bd? sd? sd? sd?"

? shorthand for degrade function

    d1 $ sound "bd*16?"
    d1 $ degrade $ sound "bd*16"

degradeBy function specifying probability (from 0 to 1)

    d1 $ degradeBy 0.25 $ sound "bd*16"

sometimesBy executing a function based on a probability

    d1 $ sometimesBy 0.75 (# crush 4) $ sound "bd arpy sn ~"

aliases for sometimesBy

    sometimes = sometimesBy 0.5
    often = sometimesBy 0.75
    rarely = sometimesBy 0.25
    almostNever = sometimesBy 0.1
    almostAlways = sometimesBy 0.9


## Creating Variation in Patterns

create cyclic variations in patterns by layering conditional logic

    d1 $ every 5 (|+| speed "0.5")
       $ every 4 (0.25 <~)
       $ every 3 (rev)
       $ sound "bd sn arpy*2 cp"
       # speed "[1 1.25 0.75 -1.5]/3"

- in addition to every
    + you can also use whenmod conditional function
    + takes two parameters
    + executes a function when
        * remainder of current loop number
        * divided by first parameter
        * is greater or equal than second parameter

the following will play a pattern
- normally for cycles 1-6
- play it in reverse for cycles 7-8

    d1 $ whenmod 8 6 (rev) $ sound "bd*2 arpy*2 cp hh*4"


## Creating "Fills" and using "const"

- think of a “fill” as a change to
    + a regular pattern that happens regularly
- e.g. every 4 cycles do “xya”
- or every 8 cycles do “abc”

pattern function fills

    d1 $ every 8 (rev) $ every 4 (density 2) $ sound "bd hh sn cp"
    d1 $ whenmod 16 14 (# speed "2") $ sound "bd arpy*2 cp bass2"

replace pattern

    d1 $ const (sound "arpy*3") $ sound "bd sn cp hh"

conditionally apply const using every or whenmod

    d1 $ whenmod 8 6 (const $ sound "arpy(3,8) bd*4") $ sound "bd sn bass2 sn"
    d1 $ every 12 (const $ sound "bd*4 sn*2") $ sound "bd sn bass2 sn"


## Composing Multi-Part Patterns

- compose new patterns from multiple other patterns
    + concatenate or “append” patterns in serial
    + “stack” and play them together in parallel

### Concatenating patterns in serial

fastcat function to add patterns one after another

    d1 $ fastcat [sound "bd sn:2" # vowel "[a o]/2",
                  sound "casio casio:1 casio:2*2"
                ]

cat (also slowcat) will maintain original playback speed of patterns

    d1 $ cat [sound "bd sn:2" # vowel "[a o]/2",
         sound "casio casio:1 casio:2*2",
         sound "drum drum:2 drum:3 drum:4*2"
        ]

- cat is a great way to create a linear sequence of patterns
    + a sequence of sequences
    + giving a larger form to multiple patterns
- randcat
    + which will play a random pattern from the list

### Playing patterns together in parallel

- stack function
    + takes a list of patterns
    + combines them into a new pattern
    + by playing all of the patterns in the list simultaneously

example

    d1 $ stack [
     sound "bd bd*2",
     sound "hh*2 [sn cp] cp future*4",
     sound (samples "arpy*8" (run 16))
    ]


## Truncating samples with "cut"

-  really long samples can cause
    + a lot of bleed
    + unwanted sound
- cut effect
    + to “choke” sound
    + stop it from playing
    + when new sample is triggered

pattern of “arpy” sounds at a low speed with lots of bleed into each sample

    d1 $ sound (samples "arpy*8" (run 8)) # speed "0.25"

stop this bleed

    d1 $ sound (samples "arpy*8" (run 8)) # speed "0.25" # cut "1"

- cut groups are global to Tidal process
- if you have two Dirt connections
    + use two different cut group values
    + to make sure the patterns don’t choke each other

example

    d1 $ sound (samples "arpy*8" (run 8)) # speed "0.25" # cut "1"
    d2 $ sound (samples "bass2*6" (run 6)) # speed "0.5" # cut "2"

    d1 $ stack [
      sound (samples "arpy*8" (run 8)) # speed "0.25" # cut "1",
      sound (samples "bass2*6" (run 6)) # speed "0.5" # cut "2" ]


## Transitions Between Patterns

- transition functions
    + anticipate
    + xfadeIn
- choose transition that will introduce another pattern
- eventually replacing the current one

example

    d1 $ sound (samples "hc*8" (iter 4 $ run 4))

    anticipate 1 $ sound (samples "bd(3,8)" (run 3))

To transition from here, simply change the pattern, and in this case also change the transition function:

    xfadeIn 1 16 $ sound "bd(5,8)"

- above will fade over 16 cycles
- from the former pattern to the given new one


## Samples

in SuperCollider, run

    Quarks.gui

-> “Dirt-Samples” -> “open folder”

    flick sid can metal future gabba sn mouth co gretsch mt arp h cp
    cr newnotes bass crow hc tabla bass0 hh bass1 bass2 oc bass3 ho
    odx diphone2 house off ht tink perc bd industrial pluck trump
    printshort jazz voodoo birds3 procshort blip drum jvbass psr
    wobble drumtraks koy rave bottle kurt latibro rm sax lighter lt
    arpy feel less stab ul


## Synths

install on Ubuntu

    sudo apt get install sc3-plugins

trigger custom SuperCollider synths from TidalCycles

    d1 $ midinote "60 62*2" # s "supersaw"

    d1 $ n "c5 d5*2" # s "supersaw"

- add suffixes “f” or “s” (flat or sharp) for half tones

two chord progression A7 D7

    d1 $ n "<[a5,cs5,e5,g5]*3 [d5,fs5,g5,c5]>" # s "supersquare" # gain "0.7"

same chords (A7 D7) this time played as ascending and descending arpeggios

    d2 $ every 4 (rev) $ n "<[g5 df5 e5 a5] [gf5 d5 c5 g5]*3>" # s "supersaw"

specify note numbers with n, but where 0 is middle c (rather than 60 midinote)

    d1 $ n "0 5" # s "supersaw"


- Many example synths
    + can be found in default-synths-extra.scd file
    + in the SuperDirt/library folder
    + or in default-synths.scd and tutorial-synths.scd
    + in the SuperDirt/synths folder

includes

    a series of tutorials: tutorial1, tutorial2, tutorial3, tutorial4, tutorial5
    examples of modulating with the cursor or sound input: pmsin, in, inr
    physical modeling synths: supermandolin, supergong, superpiano, superhex
    a basic synth drumkit: superkick, superhat, supersnare, superclap, super808
    four analogue-style synths: supersquare, supersaw, superpwm, supercomparator
    two digital-style synths: superchip, supernoise

- find the SuperDirt folder
    + run Quarks.folder in supercollider
    + full folder location should appear in postwindow
    + which is usually in the bottom right
- many of the above synths
    + accept additional Tidal Parameters
    + or interpret the usual parameters in a slightly different way
- for complete documentation
    + see default-synths.scd

some examples to try

```
d1 $ jux (# accelerate "-0.1") $ s "supermandolin*8" # midinote "[80!6 78]/8"
 # sustain "1 0.25 2 1"

d1 $ midinote (slow 2 $ (run 8) * 7 + 50) # s "supergong" # decay "[1 0.2]/4"
 # voice "[0.5 0]/8" # sustain (slow 16 $ range 5 0.5 $ saw1)

d1 $ sound "superhat:0*8" # sustain "0.125!6 1.2" # accelerate "[0.5 -0.5]/4"

d1 $ s "super808 supersnare" # n (irand 5)
 # voice "0.2" # decay "[2 0.5]/4" # accelerate "-0.1" # sustain "0.5" # speed "[0.5 2]/4"

d1 $ n (slow 8 "[[c5 e5 g5 c6]*4 [b4 e5 g5 b5]*4]") # s "superpiano"
 # velocity "[1.20 0.9 0.8 1]"

d1 $ n (slow 8 $ "[[c4,e4,g4,c5]*4 [e4,g4,b5,e5]*4]" + "<12 7>") # s "superpiano"
 # velocity (slow 8 $ range 0.8 1.1 sine) # sustain "8"

d1 $ n "[c2 e3 g4 c5 c4 c3]/3" # s "[superpwm supersaw supersquare]/24" # sustain "0.5"
 # voice "0.9" # semitone "7.9" # resonance "0.3" # lfo "3" # pitch1 "0.5" # speed "0.25 1"

d1 $ every 16 (density 24 . (|+| midinote "24") . (# sustain "0.3") . (# attack "0.05"))
 $ s "supercomparator/4" # midinote ((irand 24) + 24)
 # sustain "8" # attack "0.5" # hold "4" # release "4"
 # voice "0.5" # resonance "0.9" # lfo "1" # speed "30" # pitch1 "4"

d1 $ n "[c2 e3 g4 c5 c4 c3]*4/3" # s "superchip" # sustain "0.1"
 # pitch2 "[1.2 1.5 2 3]" # pitch3 "[1.44 2.25 4 9]"
 # voice (slow 4 "0 0.25 0.5 0.75") # slide "[0 0.1]/8" # speed "-4"

d2 $ every 4 (echo (negate 3/32)) $ n "c5*4" # s "supernoise"
 # accelerate "-2" # speed "1" # sustain "0.1 ! ! 1" # voice "0.0"

d1 $ s "supernoise/8" # midinote ((irand 10) + 30) # sustain "8"
 # accelerate "0.5" # voice "0.5" # pitch1 "0.15" # slide "-0.5" # resonance "0.7"
 # attack "1" # release "20" # room "0.9" # size "0.9" # orbit "1"
```
