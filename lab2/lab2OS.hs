-- Created by Ivan Martsilenko SADMT-4
-- parser for lab 2 OS
-- variant ?

module Test where
import System.IO
import Control.Monad

subtotals :: String -> [Int]
subtotals c = map sum (map (map readInt) (map words (lines c)))
    where
        readInt = read :: String -> Int

calc fname = do
    contents <- readFile fname
    print $ subtotals contents
    print $ sum (subtotals contents)
