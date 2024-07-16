{-# LANGUAGE TypeFamilies #-}

-- |
-- Module      : Effectful.Process.Typed
-- Description : effectful bindings for typed-process
-- Copyright   : (c) 2022 Dominik Peteler
-- License     : BSD-3-Clause
-- Stability   : stable
--
-- This module provides [effectful](https://hackage.haskell.org/package/effectful)
-- bindings for [typed-process](https://hackage.haskell.org/package/typed-process).
module Effectful.Process.Typed (
    -- * Process effect
    TypedProcess,
    runTypedProcess,

    -- * Launch a process
    startProcess,
    stopProcess,
    withProcessWait,
    withProcessWait_,
    withProcessTerm,
    withProcessTerm_,
    readProcess,
    readProcess_,
    runProcess,
    runProcess_,
    readProcessStdout,
    readProcessStdout_,
    readProcessStderr,
    readProcessStderr_,
    readProcessInterleaved,
    readProcessInterleaved_,

    -- * Process exit code
    waitExitCode,
    getExitCode,
    checkExitCode,

    -- * Re-exports from "System.Process.Typed"
    module Reexport,
) where

import System.Process.Typed as Reexport hiding (
    checkExitCode,
    getExitCode,
    readProcess,
    readProcessInterleaved,
    readProcessInterleaved_,
    readProcessStderr,
    readProcessStderr_,
    readProcessStdout,
    readProcessStdout_,
    readProcess_,
    runProcess,
    runProcess_,
    startProcess,
    stopProcess,
    waitExitCode,
    withProcessTerm,
    withProcessTerm_,
    withProcessWait,
    withProcessWait_,
 )

import Data.ByteString.Lazy (ByteString)
import qualified System.Process.Typed as PT

import Effectful
import Effectful.Dispatch.Static
import qualified Effectful.Process

----------------------------------------
-- Effect & Handler

-- | We provide a type synonym for the 'Effectful.Process.Process' effect since
-- it clashes with 'PT.Process' type of @typed-process@.
type TypedProcess = Effectful.Process.Process

-- | This is merely an alias for 'Effectful.Process.runProcess' since that name
-- clashes with 'runProcess', i.e.:
--
-- > runTypedProcess = Effectful.Process.runProcess
runTypedProcess :: (IOE :> es) => Eff (TypedProcess : es) a -> Eff es a
runTypedProcess = Effectful.Process.runProcess

----------------------------------------
-- Launch a process

-- | Lifted 'PT.startProcess'.
startProcess
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderr
    -> Eff es (PT.Process stdin stdout stderr)
startProcess = unsafeEff_ . PT.startProcess

-- | Lifted 'PT.stopProcess'.
stopProcess :: (TypedProcess :> es) => PT.Process stdin stdout stderr -> Eff es ()
stopProcess = unsafeEff_ . PT.stopProcess

-- | Lifted 'PT.withProcessWait'.
withProcessWait
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderr
    -> (PT.Process stdin stdout stderr -> Eff es a)
    -> Eff es a
withProcessWait = liftWithProcess PT.withProcessWait

-- | Lifted 'PT.withProcessWait_'.
withProcessWait_
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderr
    -> (PT.Process stdin stdout stderr -> Eff es a)
    -> Eff es a
withProcessWait_ = liftWithProcess PT.withProcessWait_

-- | Lifted 'PT.withProcessTerm'.
withProcessTerm
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderr
    -> (PT.Process stdin stdout stderr -> Eff es a)
    -> Eff es a
withProcessTerm = liftWithProcess PT.withProcessTerm

-- | Lifted 'PT.withProcessTerm_'.
withProcessTerm_
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderr
    -> (PT.Process stdin stdout stderr -> Eff es a)
    -> Eff es a
withProcessTerm_ = liftWithProcess PT.withProcessTerm_

-- | Lifted 'PT.readProcess'.
readProcess
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdoutIgnored stderrIgnored
    -> Eff es (ExitCode, ByteString, ByteString)
readProcess = unsafeEff_ . PT.readProcess

-- | Lifted 'PT.readProcess_'.
readProcess_
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdoutIgnored stderrIgnored
    -> Eff es (ByteString, ByteString)
readProcess_ = unsafeEff_ . PT.readProcess_

-- | Lifted 'PT.runProcess'.
runProcess
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderr
    -> Eff es ExitCode
runProcess = unsafeEff_ . PT.runProcess

-- | Lifted 'PT.runProcess_'.
runProcess_
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderr
    -> Eff es ()
runProcess_ = unsafeEff_ . PT.runProcess_

-- | Lifted 'PT.readProcessStdout'.
readProcessStdout
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdoutIgnored stderr
    -> Eff es (ExitCode, ByteString)
readProcessStdout = unsafeEff_ . PT.readProcessStdout

-- | Lifted 'PT.readProcessStdout_'.
readProcessStdout_
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdoutIgnored stderr
    -> Eff es ByteString
readProcessStdout_ = unsafeEff_ . PT.readProcessStdout_

-- | Lifted 'PT.readProcessStderr'.
readProcessStderr
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderrIgnored
    -> Eff es (ExitCode, ByteString)
readProcessStderr = unsafeEff_ . PT.readProcessStderr

-- | Lifted 'PT.readProcessStderr_'.
readProcessStderr_
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdout stderrIgnored
    -> Eff es ByteString
readProcessStderr_ = unsafeEff_ . PT.readProcessStderr_

-- | Lifted 'PT.readProcessInterleaved'.
readProcessInterleaved
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdoutIgnored stderrIgnored
    -> Eff es (ExitCode, ByteString)
readProcessInterleaved = unsafeEff_ . PT.readProcessInterleaved

-- | Lifted 'PT.readProcessInterleaved_'.
readProcessInterleaved_
    :: (TypedProcess :> es)
    => PT.ProcessConfig stdin stdoutIgnored stderrIgnored
    -> Eff es ByteString
readProcessInterleaved_ = unsafeEff_ . PT.readProcessInterleaved_

----------------------------------------
-- Process exit code

-- | Lifted 'PT.waitExitCode'.
waitExitCode
    :: (TypedProcess :> es)
    => PT.Process stdin stdout stderr
    -> Eff es ExitCode
waitExitCode = unsafeEff_ . PT.waitExitCode

---- | Lifted 'PT.waitExitCodeSTM'.
-- waitExitCodeSTM :: TypedProcess :> es
--                => PT.Process stdin stdout stderr
--                -> Eff es ExitCode
-- waitExitCodeSTM = unsafeEff_ . PT.waitExitCode

-- | Lifted 'PT.getExitCode'.
getExitCode
    :: (TypedProcess :> es)
    => PT.Process stdin stdout stderr
    -> Eff es (Maybe ExitCode)
getExitCode = unsafeEff_ . PT.getExitCode

---- | Lifted 'PT.getExitCodeSTM'.
-- getExitCodeSTM :: TypedProcess :> es
--               => PT.Process stdin stdout stderr
--               -> Eff es (Maybe ExitCode)
-- getExitCodeSTM = unsafeEff_ . PT.getExitCodeSTM

-- | Lifted 'PT.checkExitCode'.
checkExitCode
    :: (TypedProcess :> es)
    => PT.Process stdin stdout stderr
    -> Eff es ()
checkExitCode = unsafeEff_ . PT.checkExitCode

---- | Lifted 'PT.checkExitCodeSTM'.
-- checkExitCodeSTM :: TypedProcess :> es
--                 => PT.Process stdin stdout stderr
--                 -> Eff es ()
-- checkExitCodeSTM = unsafeEff_ . PT.checkExitCodeSTM

----------------------------------------
-- Helpers

liftWithProcess
    :: (TypedProcess :> es)
    => (PT.ProcessConfig stdin stdout stderr -> (PT.Process stdin stdout stderr -> IO a) -> IO a)
    -> PT.ProcessConfig stdin stdout stderr
    -> (PT.Process stdin stdout stderr -> Eff es a)
    -> Eff es a
liftWithProcess k pc f = unsafeEff $ \es ->
    seqUnliftIO es $ \runInIO ->
        k pc (runInIO . f)
