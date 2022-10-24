#reference:https://bioconductor.org/packages/devel/bioc/vignettes/MicrobiotaProcess/inst/doc//MicrobiotaProcess.html

#安装MicrobiotaProcess包
if (!requireNamespace("BiocManager", quietly=TRUE)) {
    install.packages("BiocManager")
}
## BiocManager::install("BiocUpgrade") ## you may need this
BiocManager::install("MicrobiotaProcess")

#加载R包
library(ggplot2) 
library(MicrobiotaProcess) 

#加载示例数据
data(mouse.time.mpse)

#############################数据输入###########################################
#如何导入biom格式的丰度表和txt格式的meta文件
# biomda <- biomformat::read_biom("demo_otu_table.biom")
# mpse <- as.MPSE(biomda)
# metada <- read.table("demo_metadata.txt", header = TRUE, sep = "\t",
#                      comment.char = "", check.names = FALSE, quote = ""
# )
# colnames(metada)[1] <- "Sample"
# mpse %<>% left_join(metada, by = c("Sample" = "Sample"))

##################9.1 alpha diversity analysis##################################
#计算稀释曲线
mouse.time.mpse %<>% mp_rrarefy()
##`%<>%`等价于 
#mouse.time <- mouse.time.mpse %>% mp_rrarefy()
##`%>%`等价于
#mouse.time <- mp_rrarefy(mouse.time.mpse)

mouse.time.mpse %<>% 
    mp_cal_rarecurve(
        .abundance = RareAbundance,
        chunks = 400
    )
mouse.time.mpse

#稀释曲线可视化
# default will display the confidence interval around smooth.
# se=TRUE
p1 <- mouse.time.mpse %>% 
    mp_plot_rarecurve(.rare = RareAbundanceRarecurve,
                      .alpha = Observe)
#等价于
# p1 <- mp_plot_rarecurve(.data = mouse.time.mpse ,
#                         .rare = RareAbundanceRarecurve, 
#                         .alpha = Observe,
# )

p1

p2 <- mouse.time.mpse %>% 
    mp_plot_rarecurve(
        .rare = RareAbundanceRarecurve, 
        .alpha = Observe, 
        .group = time
    ) +
    scale_color_manual(values=c("#00A087FF", "#3C5488FF")) +
    scale_fill_manual(values=c("#00A087FF", "#3C5488FF"), guide="none")

p2

p3 <- mouse.time.mpse %>% 
    mp_plot_rarecurve(
        .rare = RareAbundanceRarecurve, 
        .alpha = "Observe", 
        .group = time, 
        plot.group = TRUE
    ) +
    scale_color_manual(values=c("#00A087FF", "#3C5488FF")) +
    scale_fill_manual(values=c("#00A087FF", "#3C5488FF"),guide="none")  
p3

p1 + p2 + p3

#计算alpha多样性指数
mouse.time.mpse %<>% mp_cal_alpha(.abundance=RareAbundance)
mouse.time.mpse

#alpha多样性指数可视化
f1 <- mouse.time.mpse %>% 
    mp_plot_alpha(
        .group=time, 
        .alpha=c(Observe, Chao1, ACE, Shannon, Simpson, Pielou)
    ) +
    scale_fill_manual(values=c("#00A087FF", "#3C5488FF"), guide="none") +
    scale_color_manual(values=c("#00A087FF", "#3C5488FF"), guide="none")

f2 <- mouse.time.mpse %>%
    mp_plot_alpha(
        .alpha=c(Observe, Chao1, ACE, Shannon, Simpson, Pielou)
    )

f1 / f2

##################9.2 Composition###############################################
mouse.time.mpse

#计算样本和组间菌群丰度
mouse.time.mpse %>%
    mp_cal_abundance( # for each samples
        .abundance = RareAbundance
    ) %>%
    mp_cal_abundance( # for each groups 
        .abundance=RareAbundance,
        .group=time
    )

#菌群组分可视化
p1 <- mouse.time.mpse %>%
    mp_plot_abundance(
        .abundance=RareAbundance,
        .group=time, 
        taxa.class = Phylum, 
        topn = 20
    )

p2 <- mouse.time.mpse %>%
    mp_plot_abundance(
        .abundance=RareAbundance, 
        .group=time,
        taxa.class = Phylum,
        topn = 20,
        plot.group = TRUE
    )

p1 + p2

h1 <- mouse.time.mpse %>%
    mp_plot_abundance(
        .abundance = RareAbundance,
        .group = time,
        taxa.class = Phylum,
        topn = 20,
        geom = 'heatmap',
        features.dist = 'euclidean',
        features.hclust = 'average',
        sample.dist = 'bray',
        sample.hclust = 'average'
    )
h1

#计算组间的OTU组分
mouse.time.mpse %<>% 
    mp_cal_venn(.abundance=RareAbundance, 
                .group=time, 
                action="add") 

p <- mouse.time.mpse %>% mp_plot_venn(.venn = vennOftime, .group = time)
p

mouse.time.mpse %<>% 
    mp_cal_upset(.abundance=RareAbundance, .group=time, action="add")

p1 <- mouse.time.mpse %>% mp_plot_upset(.group=time, .upset=ggupsetOftime)
p1

p + p1

##################9.3 Beta diversity############################################
#计算样本间距离
# 标准化
# mp_decostand wraps the decostand of vegan, which provides
# many standardization methods for community ecology.
# default is hellinger, then the abundance processed will
# be stored to the assays slot. 
mouse.time.mpse %<>% 
    mp_decostand(.abundance=Abundance)

mouse.time.mpse #标准化后的结果在“hellinger”列中

mouse.time.mpse %<>% mp_cal_dist(.abundance=hellinger, distmethod="bray")
p1 <- mouse.time.mpse %>% mp_plot_dist(.distmethod = bray, .group = time)

p1 %>% set_scale_theme(
    x = scale_fill_manual(
        values=c("orange", "deepskyblue"), 
        guide = guide_legend(
            keywidth = 1, 
            keyheight = 0.5, 
            title.theme = element_text(size=8),
            label.theme = element_text(size=6)
        )
    ), 
    aes_var = time # specific the name of variable 
) %>%
    set_scale_theme(
        x = scale_color_gradient(
            guide = guide_legend(keywidth = 0.5, keyheight = 0.5)
        ),
        aes_var = bray
    ) %>%
    set_scale_theme(
        x = scale_size_continuous(
            range = c(0.1, 3),
            guide = guide_legend(keywidth = 0.5, keyheight = 0.5)
        ),
        aes_var = bray
    )

#降维
mouse.time.mpse %<>% 
    mp_cal_pcoa(.abundance=hellinger, distmethod="bray")

p1 <- mouse.time.mpse %>%
    mp_plot_ord(
        .ord = pcoa, 
        .group = time, 
        .color = time, 
        .size = 1.2,
        .alpha = 1,
        ellipse = TRUE,
        show.legend = FALSE # don't display the legend of stat_ellipse
    ) +
    scale_fill_manual(values=c("#00A087FF", "#3C5488FF")) +
    scale_color_manual(values=c("#00A087FF", "#3C5488FF")) 
p1

# We also can perform adonis or anosim to check whether it is significant to the dissimilarities of groups.
mouse.time.mpse %<>%
    mp_adonis(.abundance=hellinger, .formula=~time, distmethod="bray", permutations=9999, action="add")
mouse.time.mpse %>% mp_extract_internal_attr(name=adonis)

##################9.4 Different analysis########################################
#计算差异
mouse.time.mpse %<>%
    mp_diff_analysis(
        .abundance = RelRareAbundanceBySample,
        .group = time,
        first.test.alpha = 0.01
    )

#可视化
p <- mouse.time.mpse %>%
    mp_plot_diff_res(
        group.abun = TRUE,
        pwidth.abun=0.1
    ) +
    scale_fill_manual(values=c("deepskyblue", "orange")) +
    scale_fill_manual(
        aesthetics = "fill_new", # The fill aes was renamed to "fill_new" for the abundance dotplot layer
        values = c("deepskyblue", "orange")
    ) +
    scale_fill_manual(
        aesthetics = "fill_new_new", # The fill aes for hight light layer of tree was renamed to 'fill_new_new'
        values = c("#E41A1C", "#377EB8", "#4DAF4A",
                   "#984EA3", "#FF7F00", "#FFFF33",
                   "#A65628", "#F781BF", "#999999"
        )
    )
p

#可视化2
f <- mouse.time.mpse %>%
    mp_plot_diff_cladogram(
        label.size = 2.5,
        hilight.alpha = .3,
        bg.tree.size = .5,
        bg.point.size = 2,
        bg.point.stroke = .25
    ) +
    scale_fill_diff_cladogram( # set the color of different group.
        values = c('deepskyblue', 'orange')
    ) +
    scale_size_continuous(range = c(1, 4))
f









