-- DB update 2023_02_17_11 -> 2023_02_17_12
-- Ambassador Jerrikar
DELETE FROM `smart_scripts` WHERE (`source_type` = 0 AND `entryorguid` = 18695);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(18695, 0, 0, 0, 0, 0, 100, 0, 3000, 6000, 10000, 15000, 0, 11, 38926, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Ambassador Jerrikar - In Combat - Cast \'Dark Strike\''),
(18695, 0, 1, 0, 0, 0, 100, 0, 8000, 16000, 18000, 24000, 0, 11, 38916, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ambassador Jerrikar - In Combat - Cast \'Diplomatic Immunity\''),
(18695, 0, 2, 0, 0, 0, 100, 0, 9000, 12000, 14000, 19000, 0, 11, 38913, 0, 0, 0, 0, 0, 5, 20, 0, 0, 0, 0, 0, 0, 0, 'Ambassador Jerrikar - In Combat - Cast \'Silence\'');

-- Kraator
DELETE FROM `smart_scripts` WHERE (`source_type` = 0 AND `entryorguid` = 18696);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(18696, 0, 0, 0, 0, 0, 100, 0, 10000, 20000, 20000, 25000, 0, 11, 39293, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 'Kraator - In Combat - Cast \'Conflagration\''),
(18696, 0, 1, 0, 0, 0, 100, 512, 15000, 15000, 15000, 30000, 0, 11, 24670, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Kraator - In Combat - Cast \'Inferno\'');

SET @CGUID := 24965;

DELETE FROM `creature` WHERE `id1` IN (18695, 18696);
INSERT INTO `creature` (`guid`, `id1`, `map`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `MovementType`, `wander_distance`) VALUES
-- Ambassador Jerrikar
(@CGUID+0, 18695, 530, 1, -4075.71, 2580.33, 135.002, 1.76514, 86400, 2, 0),
(@CGUID+1, 18695, 530, 1, -4465.49, 1741.74, 159.227, 5.19891, 100800, 2, 0),
(@CGUID+2, 18695, 530, 1, -4169.96, 516.327, 26.1044, 3.79743, 108000, 2, 0),
(@CGUID+3, 18695, 530, 1, -3361.35, 1196.06, 62.5299, 4.75752, 115200, 2, 0),
(@CGUID+4, 18695, 530, 1, -3028.02, 1581.67, 64.2494, 2.03534, 122400, 2, 0),
-- Kraator
(@CGUID+5, 18696, 530, 0, -4428.79, 1879.54, 159.279, 3.89207, 86400, 2, 0),
(@CGUID+6, 18696, 530, 0, -3751.22, 902.85, 71.8097, 0.152557, 93600, 1, 15),
(@CGUID+7, 18696, 530, 0, -2397.45, 1727.58, -0.901711, 3.14493, 100800, 1, 15),
(@CGUID+8, 18696, 530, 0, -3434.12, 1966.03, 73.1387, 4.16987, 115200, 1, 15);

DELETE FROM `creature_addon` WHERE (`guid` IN (@CGUID+0,@CGUID+1,@CGUID+2,@CGUID+3,@CGUID+4,@CGUID+5));
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `visibilityDistanceType`, `auras`) VALUES
(@CGUID+0, (@CGUID+0)*10, 0, 0, 1, 0, 0, ''),
(@CGUID+1, (@CGUID+1)*10, 0, 0, 1, 0, 0, ''),
(@CGUID+2, (@CGUID+2)*10, 0, 0, 1, 0, 0, ''),
(@CGUID+3, (@CGUID+3)*10, 0, 0, 1, 0, 0, ''),
(@CGUID+4, (@CGUID+4)*10, 0, 0, 1, 0, 0, ''),
(@CGUID+5, (@CGUID+5)*10, 0, 0, 0, 0, 0, '');

DELETE FROM `waypoint_data` WHERE `id` IN ((@CGUID+0)*10,(@CGUID+1)*10,(@CGUID+2)*10,(@CGUID+3)*10,(@CGUID+4)*10,(@CGUID+5)*10);
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`) VALUES
-- Ambassador Jerrikar
((@CGUID+0)*10, 1, -4075.71, 2580.33, 135.002),
((@CGUID+0)*10, 2, -4057.45, 2580.98, 129.419),
((@CGUID+0)*10, 3, -4016.42, 2603.85, 114.945),
((@CGUID+0)*10, 4, -3971.13, 2618.28, 105.677),
((@CGUID+0)*10, 5, -3931.96, 2620.31, 103.518),
((@CGUID+0)*10, 6, -3891.68, 2609.75, 94.2714),
((@CGUID+0)*10, 7, -3861.79, 2588.95, 92.7909),
((@CGUID+0)*10, 8, -3811.96, 2593.8, 90.239),
((@CGUID+0)*10, 9, -3798.66, 2606.71, 90.3513),
((@CGUID+0)*10, 10, -3795.06, 2630.71, 92.2314),
((@CGUID+0)*10, 11, -3795.33, 2657.06, 101.73),
((@CGUID+0)*10, 12, -3779.87, 2668.97, 101.232),
((@CGUID+0)*10, 13, -3693.65, 2668.37, 107.487),
((@CGUID+1)*10, 1, -4465.49, 1741.74, 159.227),
((@CGUID+1)*10, 2, -4468.25, 1715.11, 159.499),
((@CGUID+1)*10, 3, -4473.41, 1702.46, 160.759),
((@CGUID+1)*10, 4, -4473.76, 1681.35, 162.28),
((@CGUID+1)*10, 5, -4497.81, 1677.15, 165.846),
((@CGUID+1)*10, 6, -4526.19, 1678.13, 175.257),
((@CGUID+1)*10, 7, -4548.16, 1678.87, 174.776),
((@CGUID+1)*10, 8, -4560.57, 1696.35, 174.429),
((@CGUID+1)*10, 9, -4534.67, 1715.35, 174.333),
((@CGUID+1)*10, 10, -4540.7, 1722.39, 174.364),
((@CGUID+1)*10, 11, -4570.23, 1673.95, 174.765),
((@CGUID+1)*10, 12, -4556.09, 1634.04, 174.413),
((@CGUID+1)*10, 13, -4549.2, 1662.49, 174.447),
((@CGUID+1)*10, 14, -4524.23, 1673.72, 175.252),
((@CGUID+1)*10, 15, -4498.8, 1671.21, 165.909),
((@CGUID+1)*10, 16, -4474.22, 1655.08, 162.994),
((@CGUID+1)*10, 17, -4460.39, 1606.96, 163.121),
((@CGUID+1)*10, 18, -4448.64, 1583.59, 164.034),
((@CGUID+1)*10, 19, -4411.11, 1580.13, 163.702),
((@CGUID+1)*10, 20, -4392.48, 1591.57, 163.285),
((@CGUID+1)*10, 21, -4368.67, 1635.85, 156.371),
((@CGUID+1)*10, 22, -4367.68, 1675.5, 157.308),
((@CGUID+1)*10, 23, -4388.41, 1705.66, 156.436),
((@CGUID+1)*10, 24, -4423.9, 1722.95, 157.067),
((@CGUID+2)*10, 1, -4169.96, 516.327, 26.1044),
((@CGUID+2)*10, 2, -4177.71, 515.877, 25.2113),
((@CGUID+2)*10, 3, -4181.79, 505.748, 27.8272),
((@CGUID+2)*10, 4, -4182.5, 492.379, 29.1442),
((@CGUID+2)*10, 5, -4195.37, 482.944, 29.7653),
((@CGUID+2)*10, 6, -4216.87, 482.478, 33.6687),
((@CGUID+2)*10, 7, -4229.05, 471.532, 40.1721),
((@CGUID+2)*10, 8, -4230.16, 457.913, 45.8716),
((@CGUID+2)*10, 9, -4217.24, 441.858, 47.4628),
((@CGUID+2)*10, 10, -4223.83, 424.661, 49.881),
((@CGUID+2)*10, 11, -4253.25, 378.726, 77.7883),
((@CGUID+2)*10, 12, -4268.08, 376.821, 79.3743),
((@CGUID+2)*10, 13, -4287.69, 350.027, 101.469),
((@CGUID+2)*10, 14, -4299.35, 330.594, 110.523),
((@CGUID+2)*10, 15, -4297.03, 309.694, 118.697),
((@CGUID+2)*10, 16, -4292.15, 296.065, 121.796),
((@CGUID+2)*10, 17, -4238.48, 271.237, 122.493),
((@CGUID+2)*10, 18, -4221.39, 274.691, 122.37),
((@CGUID+2)*10, 19, -4215.31, 280.698, 122.542),
((@CGUID+2)*10, 20, -4210.35, 293.733, 122.793),
((@CGUID+2)*10, 21, -4207.68, 312.923, 123.018),
((@CGUID+2)*10, 22, -4195.38, 321.624, 122.314),
((@CGUID+2)*10, 23, -4196.27, 331.13, 119.068),
((@CGUID+2)*10, 24, -4228.72, 322.865, 122.659),
((@CGUID+3)*10, 1, -3361.35, 1196.06, 62.5307),
((@CGUID+3)*10, 2, -3365.38, 1173.51, 59.1371),
((@CGUID+3)*10, 3, -3373.31, 1147.16, 53.9433),
((@CGUID+3)*10, 4, -3372.94, 1129.12, 49.5635),
((@CGUID+3)*10, 5, -3377.21, 1118.26, 48.4891),
((@CGUID+3)*10, 6, -3367.83, 1077.38, 45.7798),
((@CGUID+3)*10, 7, -3342.6, 1054.95, 45.4535),
((@CGUID+3)*10, 8, -3342.39, 1043.87, 43.4964),
((@CGUID+3)*10, 9, -3357.42, 1034.57, 41.0994),
((@CGUID+3)*10, 10, -3365.29, 1017.92, 33.716),
((@CGUID+3)*10, 11, -3358.28, 986.865, 28.8074),
((@CGUID+3)*10, 12, -3343.54, 975.584, 30.8439),
((@CGUID+3)*10, 13, -3331.61, 970.294, 29.6034),
((@CGUID+3)*10, 14, -3315.27, 966.89, 32.3896),
((@CGUID+3)*10, 15, -3302.97, 967.504, 34.9652),
((@CGUID+3)*10, 16, -3291.19, 975.843, 38.2663),
((@CGUID+3)*10, 17, -3278.5, 991.971, 42.9526),
((@CGUID+3)*10, 18, -3276.74, 1007.7, 47.4324),
((@CGUID+3)*10, 19, -3273.8, 1018.81, 48.3504),
((@CGUID+3)*10, 20, -3247.58, 1044.13, 54.8317),
((@CGUID+3)*10, 21, -3282, 1113.23, 55.3277),
((@CGUID+3)*10, 22, -3281.22, 1143.76, 54.9456),
((@CGUID+3)*10, 23, -3304.47, 1170.87, 57.3955),
((@CGUID+3)*10, 24, -3329.39, 1161.3, 57.2152),
((@CGUID+3)*10, 25, -3343.26, 1173.6, 59.9309),
((@CGUID+3)*10, 26, -3345.25, 1178.61, 60.6426),
((@CGUID+4)*10, 1, -3028.02, 1581.67, 64.2494),
((@CGUID+4)*10, 2, -3028.36, 1586.81, 64.194),
((@CGUID+4)*10, 3, -3028.46, 1596.54, 59.418),
((@CGUID+4)*10, 4, -3064.63, 1628.56, 60.3787),
((@CGUID+4)*10, 5, -3054.28, 1645.89, 64.0629),
((@CGUID+4)*10, 6, -3059.14, 1668.62, 67.1315),
((@CGUID+4)*10, 7, -3097.5, 1706.17, 68.492),
((@CGUID+4)*10, 8, -3082.57, 1740.85, 72.1624),
((@CGUID+4)*10, 9, -3059.49, 1742.78, 75.1391),
((@CGUID+4)*10, 10, -3046.86, 1752.01, 75.399),
((@CGUID+4)*10, 11, -3023.05, 1733.12, 75.1709),
((@CGUID+4)*10, 12, -3001.55, 1739.61, 75.5879),
((@CGUID+4)*10, 13, -2997.25, 1722.5, 74.1977),
((@CGUID+4)*10, 14, -2994.86, 1702.15, 71.6494),
((@CGUID+4)*10, 15, -2967.53, 1666.31, 66.9312),
((@CGUID+4)*10, 16, -2950.68, 1643.32, 57.4303),
((@CGUID+4)*10, 17, -2975.16, 1615.84, 54.3787),
((@CGUID+4)*10, 18, -2979.98, 1606.67, 55.4944),
((@CGUID+4)*10, 19, -3003.71, 1605.77, 58.9754),
((@CGUID+4)*10, 20, -3028.1, 1596.8, 59.3902),
((@CGUID+4)*10, 21, -3027.81, 1585.9, 64.2028),
-- Kraator
((@CGUID+5)*10, 1, -4394.72, 1864.71, 157.072),
((@CGUID+5)*10, 2, -4461.79, 1886.59, 160.185),
((@CGUID+5)*10, 3, -4483.14, 1923.24, 147.075),
((@CGUID+5)*10, 4, -4482.07, 1945.44, 137.237),
((@CGUID+5)*10, 5, -4466.53, 1966.46, 122.571),
((@CGUID+5)*10, 6, -4450.53, 1991.66, 104.083),
((@CGUID+5)*10, 7, -4469.15, 1990.33, 111.189),
((@CGUID+5)*10, 8, -4468.9, 1970.66, 121.295),
((@CGUID+5)*10, 9, -4486.36, 1927.62, 146.364),
((@CGUID+5)*10, 10, -4450.83, 1884.11, 160.943);

-- Pooling
DELETE FROM `pool_template` WHERE `entry`=1074 AND `description` LIKE '%Ambassador Jerrikar%';
DELETE FROM `pool_template` WHERE `entry`=1116 AND `description`='Kraator (18696)';
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES
(1074, 1, 'Ambassador Jerrikar (18695)'),
(1116, 1, 'Kraator (18696)');

DELETE FROM `pool_creature` WHERE `pool_entry`=1074 AND `description` LIKE '%Ambassador Jerrikar%';
DELETE FROM `pool_creature` WHERE `pool_entry`=1116 AND `description`='Kraator (18696)';
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(@CGUID+0, 1074, 0, 'Ambassador Jerrikar (18695)'),
(@CGUID+1, 1074, 0, 'Ambassador Jerrikar (18695)'),
(@CGUID+2, 1074, 0, 'Ambassador Jerrikar (18695)'),
(@CGUID+3, 1074, 0, 'Ambassador Jerrikar (18695)'),
(@CGUID+4, 1074, 0, 'Ambassador Jerrikar (18695)'),
(@CGUID+5, 1116, 0, 'Kraator (18696)'),
(@CGUID+6, 1116, 0, 'Kraator (18696)'),
(@CGUID+7, 1116, 0, 'Kraator (18696)'),
(@CGUID+8, 1116, 0, 'Kraator (18696)');

-- Remove DISABLE_MOVE from Ambassador Jerrikar
UPDATE `creature_template` SET `unit_flags`=`unit_flags`&~4 WHERE (`entry` = 18695);
