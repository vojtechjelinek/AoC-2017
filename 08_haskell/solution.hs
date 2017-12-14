import System.IO
import System.Environment
import Data.List.Split
import qualified Data.Map as Map

data Operation = Operation { register :: String
                           , operationType :: String
                           , value :: Int
                           } deriving (Show)

data Command = Command { operation :: Operation
                       , comparator :: Operation
                       } deriving (Show)

type Registers = Map.Map String Int

createCommand :: [[Char]] -> Command
createCommand line = Command { operation = Operation {
                                 register = line!!0,
                                 operationType = line!!1,
                                 value = read (line!!2)
                               }
                             , comparator = Operation {
                                 register = line!!4,
                                 operationType = line!!5,
                                 value = read (line!!6)
                               }
                             }

createCommands :: [[[Char]]] -> [Command]
createCommands = map createCommand

getRegister :: String -> Registers -> Int
getRegister = Map.findWithDefault 0

evaluateComparison :: Operation -> Registers -> Bool
evaluateComparison (Operation reg ">" val) registers =
    (getRegister reg registers) > val
evaluateComparison (Operation reg ">=" val) registers =
    (getRegister reg registers) >= val
evaluateComparison (Operation reg "<" val) registers =
    (getRegister reg registers) < val
evaluateComparison (Operation reg "<=" val) registers =
    (getRegister reg registers) <= val
evaluateComparison (Operation reg "!=" val) registers =
    (getRegister reg registers) /= val
evaluateComparison (Operation reg "==" val) registers =
    (getRegister reg registers) == val

getMaxValue :: Registers -> Int
getMaxValue registers = maximum (Map.elems registers)

evaluateOperation :: Operation -> Registers -> Registers
evaluateOperation (Operation reg "dec" val) registers =
  Map.insertWith (+) reg (-val) registers
evaluateOperation (Operation reg "inc" val) registers =
  Map.insertWith (+) reg val registers

executeCommand :: Command -> Registers -> Int -> (Registers, Int)
executeCommand command registers maxim =
    if evaluateComparison (comparator command) registers
        then
            let { newRegisters = evaluateOperation (operation command) registers;
                  maxValue = getMaxValue newRegisters} in
                      if maxValue > maxim
                          then (newRegisters, maxValue)
                          else (newRegisters, maxim)
        else (registers, maxim)

executeCommands :: [Command] -> (Registers, Int) -> (Registers, Int)
executeCommands [] tuple = tuple
executeCommands (command:s) (registers, maxim) =
    executeCommands s (executeCommand command registers maxim)

main = do
    contents <- readFile "input.txt"
    let tuple = (executeCommands (createCommands (map (splitOn " ") (endBy "\n" contents))) (Map.empty, 0)) in
        print (getMaxValue (fst tuple), snd tuple)
