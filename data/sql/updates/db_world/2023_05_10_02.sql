-- DB update 2023_05_10_01 -> 2023_05_10_02
-- Update spawnposition
UPDATE `creature` SET `position_x` = -2347.824219, `position_y` = -11363.384766, `position_z` = 27.942247, `orientation` = 1.895, `wander_distance` = 0, `MovementType` = 0 WHERE `guid` = 62369 AND `id1` = 17337;
UPDATE `creature` SET `position_x` = -2571.970459, `position_y` = -11343.209961, `position_z` = 25.304287, `wander_distance` = 10, `MovementType` = 1 WHERE `guid` = 62370 AND `id1` = 17338;
UPDATE `creature` SET `position_x` = -2551.867188, `position_y` = -11275.340820, `position_z` = 36.856060, `wander_distance` = 10, `MovementType` = 1 WHERE `guid` = 62391 AND `id1` = 17339;
UPDATE `creature` SET `position_x` = -2442.700684, `position_y` = -11346.622070, `position_z` = 30.975761, `wander_distance` = 10, `MovementType` = 1 WHERE `guid` = 62356 AND `id1` = 17337;
UPDATE `creature` SET `position_x` = -2331.138184, `position_y` = -11346.259766, `position_z` = 30.188799, `wander_distance` = 10, `MovementType` = 1 WHERE `guid` = 62388 AND `id1` = 17338;
UPDATE `creature` SET `position_x` = -2394.431396, `position_y` = -11369.132813, `position_z` = 30.477755, `wander_distance` = 10, `MovementType` = 1 WHERE `guid` = 62387 AND `id1` = 17338;
UPDATE `creature` SET `position_x` = -2418.719727, `position_y` = -11211.605469, `position_z` = 24.287613, `wander_distance` = 0,  `MovementType` = 0 WHERE `guid` = 62399 AND `id1` = 17339;
UPDATE `creature` SET `position_x` = -2476.131348, `position_y` = -11252.391602, `position_z` = 28.754663 WHERE `guid` = 62358 AND `id1` = 17337;
UPDATE `creature` SET `position_x` = -2510.596924, `position_y` = -11405.423828, `position_z` = 39.383987 WHERE `guid` = 62371 AND `id1` = 17338;
UPDATE `creature` SET `position_x` = -2474.837158, `position_y` = -11339.492188, `position_z` = 33.152016 WHERE `guid` = 62390 AND `id1` = 17339;
UPDATE `creature` SET `wander_distance` = 0, `MovementType` = 0 WHERE `guid` IN (62394,62357,62404,62368,62403,62397,62396,62365,62366,62372,62389,62355,62378,62382,62373,62379);

-- Waypoints & Text for Boss
UPDATE `creature` SET `position_x` = -2542.234375, `position_y` = -11328.796875, `position_z` = 22.867491, `orientation` = 0.662011, `wander_distance` = 0, `MovementType` = 0, `spawntimesecs` = 120 WHERE `guid` = 84399 AND `id1` = 17528;

-- Tzerak SAI
SET @ENTRY := 17528;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,1752800,0,0,0,2,1,0,0,0,0,0,0,0,'Tzerak - On Respawn - Start Waypoint Aggressive'),
(@ENTRY,0,1,2,40,0,100,0,15,1752800,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.01264,'Tzerak - On Waypoint 15 Reached - Set Orientation 3.01264'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,41,120000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tzerak - On Waypoint 15 Reached - Despawn In 120000 ms'),
(@ENTRY,0,3,4,40,0,100,0,1,1752800,0,0,54,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tzerak - On Waypoint 1 Reached - Pause Waypoint'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,1,0,10000,0,0,0,0,1,0,0,0,0,0,0,0,'Tzerak - On Waypoint 1 Reached - Say Line 0');

DELETE FROM `waypoints` WHERE `entry` = 1752800;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `point_comment`) VALUES
(1752800, 1, -2542.23, -11328.8, 22.8675, NULL, 0, 'Tzerak'),
(1752800, 2, -2524.86, -11312.4, 25.5424, NULL, 0, 'Tzerak'),
(1752800, 3, -2516.88, -11305, 29.4704, NULL, 0, 'Tzerak'),
(1752800, 4, -2504.32, -11295.3, 32.0184, NULL, 0, 'Tzerak'),
(1752800, 5, -2484.1, -11275.5, 33.354, NULL, 0, 'Tzerak'),
(1752800, 6, -2470.59, -11269.7, 30.1162, NULL, 0, 'Tzerak'),
(1752800, 7, -2434.22, -11274.3, 30.9809, NULL, 0, 'Tzerak'),
(1752800, 8, -2417.37, -11278, 30.3146, NULL, 0, 'Tzerak'),
(1752800, 9, -2407.49, -11286, 33.2194, NULL, 0, 'Tzerak'),
(1752800, 10, -2395.33, -11298.7, 29.1992, NULL, 0, 'Tzerak'),
(1752800, 11, -2384.19, -11290, 31.0475, NULL, 0, 'Tzerak'),
(1752800, 12, -2359.67, -11270.9, 28.8272, NULL, 0, 'Tzerak'),
(1752800, 13, -2347.69, -11268.9, 30.022, NULL, 0, 'Tzerak'),
(1752800, 14, -2315.89, -11266.3, 35.8439, NULL, 0, 'Tzerak'),
(1752800, 15, -2315.89, -11266.3, 35.8439, NULL, 0, 'Tzerak');

DELETE FROM `creature_text` WHERE `CreatureID`=17528;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES 
(17528, 0, 0, 'Fools! Weaklings! Tzerak has no need of your assistance!', 14, 0, 100, 0, 0, 0, 14070, 0, 'Tzerak');

-- Waypoints for Trashspawn
SET @NPC := 62392;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2521.73,-11261.4,36.1656,30000,0,1.7332),
(@PATH,2,-2522.38,-11282,36.231,300000,0,1.13446);

SET @NPC := 62361;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2380.99,-11345,28.0672,150000,0,6.26573),
(@PATH,2,-2360.98,-11344.1,27.9434,30000,0,6.18013),
(@PATH,3,-2380.99,-11345,28.0672,150000,0,6.26573);

SET @NPC := 62395;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2448.85,-11322.6,30.4971,50000,0,0.907571),
(@PATH,2,-2436.76,-11310.8,28.9112,30000,0,0.686272),
(@PATH,3,-2448.85,-11322.6,30.4971,250000,0,0.907571);

SET @NPC := 62398;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2461.01,-11392.8,37.3679,60000,0,4.08407),
(@PATH,2,-2471.12,-11398,37.3497,30000,0,3.41946),
(@PATH,3,-2461.01,-11392.8,37.3679,240000,0,4.08407);

SET @NPC := 62385;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2519.93,-11124.8,16.9338,100000,0,4.79965),
(@PATH,2,-2523.45,-11140,16.8102,30000,0,4.45305),
(@PATH,3,-2519.93,-11124.8,16.9338,180000,0,4.79965);

SET @NPC := 62384;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2314.89,-11196.5,14.0951,180000,0,2.09439),
(@PATH,2,-2322.53,-11181.1,13.9421,30000,0,2.20995),
(@PATH,3,-2314.89,-11196.5,14.0951,120000,0,2.09439);

SET @NPC := 62400;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2346.76,-11178.5,14.0671,160000,0,5.70723),
(@PATH,2,-2328.47,-11177.5,13.9423,50000,0,6.18407),
(@PATH,3,-2346.76,-11178.5,14.0671,140000,0,5.70723);

SET @NPC := 62374;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2425.44,-11239.8,24.389,40000,0,2.33874),
(@PATH,2,-2430.69,-11227.7,23.4846,30000,0,2.01753),
(@PATH,3,-2425.44,-11239.8,24.389,260000,0,2.33874);

SET @NPC := 62363;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2417.53,-11219.3,24.298,0,0,3.83202),
(@PATH,2,-2420.09,-11224.6,24.2207,0,0,4.58285),
(@PATH,3,-2417.4,-11234.2,24.287,0,0,5.35254),
(@PATH,4,-2407.2,-11243.3,25.2017,0,0,5.6392),
(@PATH,5,-2384.96,-11255.4,28.4475,0,0,5.79235),
(@PATH,6,-2365.68,-11262.6,28.6973,0,0,6.03975),
(@PATH,7,-2350.64,-11264.9,29.9547,0,0,6.2361),
(@PATH,8,-2327.79,-11264.1,34.9404,10000,0,0.0864284),
(@PATH,9,-2349.93,-11264.9,30.0943,0,0,3.14163),
(@PATH,10,-2365.42,-11262.5,28.7001,0,0,2.85496),
(@PATH,11,-2384.81,-11255.5,28.4646,0,0,2.71751),
(@PATH,12,-2406.78,-11243.7,25.2684,0,0,2.56436),
(@PATH,13,-2417.21,-11234.5,24.289,0,0,2.3523),
(@PATH,14,-2420.1,-11225.2,24.2164,0,0,1.70435),
(@PATH,15,-2418.02,-11219.3,24.2921,0,0,0.344823),
(@PATH,16,-2413.14,-11217.1,24.4672,300000,0,3.40339);

SET @NPC := 62393;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `wander_distance`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`, `delay`, `action`, `orientation`) VALUES
(@PATH,1,-2525.62,-11248.4,36.167,0,0,5.98869),
(@PATH,2,-2516.71,-11251.2,36.167,0,0,5.89052),
(@PATH,3,-2504.22,-11260.2,36.167,0,0,5.65097),
(@PATH,4,-2487.4,-11265.7,33.7935,0,0,6.03189),
(@PATH,5,-2473.42,-11269.1,30.2829,0,0,6.05938),
(@PATH,6,-2448.13,-11275.2,29.8481,0,0,6.10257),
(@PATH,7,-2422.05,-11279.3,29.9044,0,0,6.13791),
(@PATH,8,-2406.46,-11281.8,32.759,0,0,2.6226),
(@PATH,9,-2380.68,-11277.7,29.0944,0,0,0.212084),
(@PATH,10,-2357.97,-11269.4,28.8948,0,0,0.116265),
(@PATH,11,-2329.64,-11267.7,34.2848,15000,0,0.0769952),
(@PATH,12,-2358.23,-11269.7,28.8781,0,0,3.35996),
(@PATH,13,-2380.33,-11277.9,29.0908,0,0,3.37959),
(@PATH,14,-2395.13,-11282,30.7833,0,0,3.08507),
(@PATH,15,-2406.13,-11281.8,32.7515,0,0,2.99868),
(@PATH,16,-2417.89,-11280.1,30.0178,0,0,2.99868),
(@PATH,17,-2446.36,-11275.3,29.9164,0,0,2.95941),
(@PATH,18,-2470.62,-11269.9,30.1313,0,0,2.9759),
(@PATH,19,-2485.65,-11266.4,33.2662,0,0,2.85338),
(@PATH,20,-2503.47,-11260.9,36.1658,0,0,2.62797),
(@PATH,21,-2517.11,-11250.9,36.1658,0,0,2.77327),
(@PATH,22,-2527.37,-11249.6,36.1658,0,0,3.32697),
(@PATH,23,-2542.37,-11253,36.2131,300000,0,6.14356);

-- Gameobjects
DELETE FROM `gameobject` WHERE `guid` IN (21191,21202,21203,21237) AND `id` IN (185047,185046,185045,181806);
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `VerifiedBuild`) VALUES
(21191, 185047, 530, 3525, 3592, 1, 1, -2546.796142578125, -11313.705078125, 23.08652687072753906, 6.224953651428222656, 0, 0, -0.02911186218261718, 0.999576151371002197, 120, 255, 1, 49343),
(21202, 185046, 530, 3525, 3592, 1, 1, -2522.584228515625, -11257.0703125, 36.05535888671875, 0.355989396572113037, 0, 0, 0.177056312561035156, 0.984200716018676757, 120, 255, 1, 49343),
(21203, 185045, 530, 3525, 3592, 1, 1, -2474.967529296875, -11399.513671875, 37.10285568237304687, 0.355989396572113037, 0, 0, 0.177056312561035156, 0.984200716018676757, 120, 255, 1, 49343),
(21237, 181806, 530, 3525, 3592, 1, 1, -2542.06787109375, -11328.0830078125, 22.86698150634765625, 3.90954136848449707, 0, 0, -0.92718315124511718, 0.37460830807685852, 120, 255, 1, 49343);
