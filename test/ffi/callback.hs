{-# LANGUAGE JavaScriptFFI, CPP #-}

module Main where

import Control.Concurrent
import Control.Concurrent.MVar

import GHCJS.Foreign
import GHCJS.Types

#ifdef __GHCJS__
foreign import javascript unsafe "$1();" runCallback :: JSFun (IO ()) -> IO ()
#else
runCallback :: JSFun (IO ()) -> IO ()
runCallback = error "not JavaScript"
#endif



main = do
  mv1 <- newEmptyMVar
  mv2 <- newEmptyMVar
  s1 <- syncCallback False (putStrLn "b" >> takeMVar mv1 >> putStrLn "error")
  s2 <- syncCallback True  (putStrLn "d" >> takeMVar mv2 >> putStrLn "f")
  putStrLn "a"
  runCallback s1
  putStrLn "c"
  runCallback s2
  putStrLn "e"
  threadDelay 1000000
  putMVar mv1 ()
  putMVar mv2 ()
  threadDelay 1000000

