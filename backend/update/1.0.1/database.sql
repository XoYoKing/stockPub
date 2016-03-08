#38
ALTER TABLE `stock_now_info`
	ADD COLUMN `timestamp_ms` bigint(32) NULL;
#38
UPDATE `stock_now_info` SET `timestamp_ms` = `timestamp` *1000;

#38
ALTER TABLE `stock_amount_info`
	ADD COLUMN `timestamp_ms` bigint(20) NOT NULL DEFAULT 0;
#38
UPDATE `stock_amount_info` SET `timestamp_ms` = `timestamp` *1000;

#38
ALTER TABLE `stock_now_info`
	ADD COLUMN `low_price` float NULL DEFAULT 0;

#38
ALTER TABLE `market_index_day_info`
	ADD COLUMN `timestamp_ms` bigint NOT NULL DEFAULT 0;

#38
UPDATE `market_index_day_info` SET `timestamp_ms` = `timestamp` *1000;

#38
ALTER TABLE `market_index_now_info`
	ADD COLUMN `timestamp_ms` bigint NOT NULL DEFAULT 0;

#38
UPDATE `market_index_now_info` SET `timestamp_ms`  = `timestamp` *1000;

UPDATE `market_index_now_info` SET `timestamp_ms` = `timestamp` ;

UPDATE `market_index_day_info` SET `timestamp_ms` = `timestamp` ;

#38
ALTER TABLE `market_index_day_info`
	ADD COLUMN `market_index_five_av_value` float NULL;

#38
ALTER TABLE `market_index_day_info`
	ADD COLUMN `market_index_ten_av_value` float NULL;

#38
ALTER TABLE `market_index_day_info`
	ADD COLUMN `market_index_twenty_av_value` float NULL;

#38
UPDATE `market_index_day_info` SET `market_index_date` = substr(`market_index_date`, 1, 8);

#38
UPDATE `market_index_now_info` SET `market_index_date` = substr(`market_index_date`, 1, 8);

#38
ALTER TABLE `market_index_day_info`
	ADD COLUMN `market_index_trade_amount` int NULL;

#48
ALTER TABLE `stock_base_info`
	ADD COLUMN `stock_alpha_info` varchar(32) NULL COMMENT '首字母缩写';

#48
#dev stock_amount_info 导入pro

#48
#dev stock_base_info 导入pro
