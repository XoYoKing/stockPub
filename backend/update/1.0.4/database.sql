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
	ADD COLUMN `talk_to_user_name` varchar(32) NULL

    
