#mydate=$(`date+%y%m%d`)

mydate=`date +"%Y%m%d"`
tar czvf $HOME/stocklogs_back/$mydate'_stock_log.tar' $HOME/stocklogs/*
rm $HOME/stocklogs/*
