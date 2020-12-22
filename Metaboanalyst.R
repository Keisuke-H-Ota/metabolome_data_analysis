# MetaboanalystR を用いたメタボロームデータ解析
# 参照 https://qiita.com/keisuke-ota/items/803c4299138b169eb9a2

rm( list=ls(all=TRUE) )

library("MetaboAnalystR")

df <- data.frame()

# メタボロームデータを代入する。

file <- paste0('MetabolomeData.csv')

# p は欠損値処理に関するパラメータ
# n1、n2、n3 は標準化方法に関するパラメータ
# 各パラメータで解析することで前処理の方法を検討する。

for (p in c(0.1, 0.5, 0.9)){
    for (n1 in c('NULL','SumNorm')){
        for (n2 in c('NULL','LogNorm')){    
            for (n3 in c('NULL','AutoNorm')){

                # データの代入

                mSet<-InitDataObjects("pktable", "stat", FALSE)
                mSet<-Read.TextData(mSet, file, "colu", "disc");
                mSet<-SanityCheckData(mSet)

                # 欠損値処理

                mSet<-RemoveMissingPercent(mSet, percent=p)
                mSet<-ImputeVar(mSet, method="min")

                # 標準化

                mSet<-PreparePrenormData(mSet)
                mSet<-Normalization(mSet, n1, n2, n3, ratio=FALSE, ratioNum=20)

                # Fold change と t 検定を実施

                mSet<-Volcano.Anal(mSet, FALSE, 2.0, 0, 0.75,F, 0.1, TRUE, "raw")

                # PLS-DA を実施。VIP score を計算

                mSet<-PLSR.Anal(mSet, reg=TRUE)
                mSet<-PLSDA.CV(mSet, "L",5, "Q2")

                # ランダムフォレストを実施。MDA を計算

                mSet<-RF.Anal(mSet, 1000,7,1)

                # 解析結果を整理

                results = cbind (as.data.frame(mSet$analSet$volcano$fc.log)[mSet$dataSet$orig.var.nms,],
                    as.data.frame(mSet$analSet$volcano$p.log)[mSet$dataSet$orig.var.nms,],
                    as.data.frame(mSet$analSet$plsda$vip.mat[,'Comp. 1'])[mSet$dataSet$orig.var.nms,],
                    as.data.frame(mSet$analSet$rf.sigmat)[mSet$dataSet$orig.var.nms,],
                    as.data.frame(mSet$dataSet$orig.var.nms))
                colnames(results) <- c('FC', 'Q_value','VIP','RF_MDA', 'metabolites')

                results <- transform(results,Normalization_method = rep(paste(n1,n2,n3), length(mSet$dataSet$orig.var.nms)))
                results <- transform(results,RemoveMissingPercent = rep(p, length(mSet$dataSet$orig.var.nms)))
                rownames(results) <- NULL

                # データの結合

                df <- rbind(df, results)

                rm(mSet)
            }   
        }   
    }
}

write.csv(df, paste0('/results.csv'), fileEncoding = "CP932")