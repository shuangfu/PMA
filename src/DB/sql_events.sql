ALTER EVENT myevent
ON SCHEDULE EVERY 1 DAY STARTS '2015-12-19 00:00:00'
DO
  UPDATE stage
  SET status = 'RUNNING',actualStartTime=now()
  WHERE stageName = '3D' AND status = 'UNBEGINNING' AND datediff(now(),starttime) >= 0;