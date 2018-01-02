import Bitwise
import Char
import Hex
import Html exposing (text)

reverse_normal l hash startPos endPos =
  let
    firstPart = List.take startPos hash
    reversedPart = List.reverse (List.take l (List.drop startPos hash))
    lastPart = List.drop (startPos + l) hash
  in
    firstPart ++ reversedPart ++ lastPart

reverse_cycle l hash startPos endPos =
  let
    slice = (List.length hash) - startPos
    reversedPart =
      List.reverse ((List.drop startPos hash) ++ (List.take endPos hash))
    nonReversedPart = List.drop endPos (List.take startPos hash)

  in
    (List.drop slice reversedPart) ++ nonReversedPart ++ (List.take slice reversedPart)

iterate lengths hash skip pos =
  case lengths of
    [] -> (hash, skip, pos)
    l::ls ->
      let
        hashLen = (List.length hash)
        newPos = ((pos + l + skip) % hashLen)
        endPos = ((pos + l) % hashLen)
      in
        if pos <= endPos then
          iterate ls (reverse_normal l hash pos endPos) (skip + 1) newPos
        else
          iterate ls (reverse_cycle l hash pos endPos) (skip + 1) newPos

iterateMultipleRounds lengths hash skip pos cycle =
  case cycle of
    0 -> hash
    _ ->
      let
        (newHash, newSkip, newPos) = iterate lengths hash skip pos
      in
        iterateMultipleRounds lengths newHash newSkip newPos (cycle - 1)

hashToHexadecimal hash =
  case hash of
    [] -> []
    _ ->
      let
        partResult = List.foldr Bitwise.xor 0 (List.take 16 hash)
        hex = Hex.toString partResult
        hexRepr = if String.length hex == 1 then "0" ++ hex else hex
      in
        [hexRepr] ++ hashToHexadecimal (List.drop 16 hash)

stringToInt string = Result.withDefault 0 (String.toInt string)

main =
  let
    lengthsText = "165,1,255,31,87,52,24,113,0,91,148,254,158,2,73,153"
    lengthsFirstPart = List.map stringToInt (String.split "," lengthsText)
    lengthsSecondPart =
      List.map Char.toCode (String.toList lengthsText) ++ [17, 31, 73, 47, 23]
    hash = List.range 0 255
  in
    text ((toString (iterateMultipleRounds lengthsFirstPart hash 0 0 1)) ++
          (String.join "" (hashToHexadecimal (iterateMultipleRounds lengthsSecondPart hash 0 0 64))))
