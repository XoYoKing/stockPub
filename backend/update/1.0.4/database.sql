#69
CREATE TABLE `stock_talk_base_info` (
	`talk_id` varchar(128) NOT NULL,
	`talk_stock_code` varchar(32) NOT NULL,
	`talk_user_id` varchar(128) NOT NULL,
	`talk_to_user_id` varchar(128) NULL,
	`talk_content` varchar(1024) NOT NULL,
	`talk_date_time` varchar(32) NOT NULL,
	`talk_timestamp_ms` bigint(32) NOT NULL,
	PRIMARY KEY (`talk_id`)
) ENGINE=InnoDB;

ALTER TABLE `stock_talk_base_info`
	ADD COLUMN `talk_to_user_name` varchar(32) NULL;

ALTER TABLE `stock_talk_base_info`
	MODIFY COLUMN `talk_to_user_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' AFTER `talk_user_id`,
	MODIFY COLUMN `talk_to_user_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' AFTER `talk_timestamp_ms`;

ALTER TABLE `stock_talk_base_info`
	ADD COLUMN `to_stock` int(32) NOT NULL COMMENT '0, 对人评论， 1 对股票评论';

ALTER TABLE `stock_talk_base_info`
    MODIFY COLUMN `talk_content` varchar(1024) CHARACTER SET utf8mb4 NOT NULL;
