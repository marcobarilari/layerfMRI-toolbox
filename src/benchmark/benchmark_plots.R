library(ggplot2)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

derivatives_size <- data.frame(process = c('raw',
                                           'freesurfer reconall',
                                           'SUMA + upsample surf',
                                           'rimify and layers'), 
                               output_GB = c(0.50,
                                            0.50 + 0.857,
                                            0.50 + 0.857 + 38,
                                            0.50 + 0.857 + 38 + 0.131),
                               order = 1:4) 

ggplot(data = derivatives_size,
       aes(y = output_GB,
           x = reorder(process, order))) +
  geom_line(color = 'darkgreen',
            group = 1,
            alpha = 0.9) +
  geom_point(color = 'darkgreen',
             shape = 16, 
             size = 4) +
  theme_classic() +
  labs(x="", y="Weight (GB)") +
  ggtitle("Disk usage per subject") +
  theme(
    text=element_text(size=18), 
    axis.line = element_line(size = 1), 
    axis.text.x = element_text(size=15,
                               colour="black",
                               angle = 30,
                               vjust = 0.5, 
                               hjust = 0.5), 
    axis.text.y = element_text(size=15, colour='black'), 
    legend.title = element_blank())

ggsave('./disk.png', device="png", units="in", width=9.54, height=4.54, dpi=300)   


benchmarkfile <- 'benchmark_v010beta_layers_20240219200801.tsv'

benchmark <- read.table(benchmarkfile,
                        header = T)

benchmark$timepoints <- 1:nrow(benchmark)

ggplot(data = benchmark,
       aes(y = Memory_Usage_Mean_GB,
           x = timepoints/120)) +
  geom_point(color = 'darkgreen',
             alpha = 0.1,
             size = 3.7,
             shape = 16) +
  # geom_smooth(method = 'smooth',
  #             span = .1, 
  #             color = 'darkgreen',
  #             size = 2.3) + 
  theme_classic() +
  labs(x="Time (~h)", y="Usage (GB)") +
  ggtitle("RAM usage per subject (over 60 GB goes into swap memory)") +
  theme(
    text=element_text(size=18), 
    axis.line = element_line(size = 1), 
    axis.text.x = element_text(size=15,colour="black",
                               angle = 0,
                               vjust = .5, 
                               hjust = 0.5), 
    axis.text.y = element_text(size=15, colour='black'), 
    legend.title = element_blank())

ggsave('./ram.png', device="png", units="in", width=9.54, height=4.54, dpi=300)   


ggplot(data = benchmark,
       aes(y = CPU_Usage_Mean_perc,
           x = timepoints/120)) +
  geom_point(color = 'darkred',
             alpha = 0.1,
             size = 3.7,
             shape = 16) +
  # geom_smooth(span = 1, 
  #             color = 'darkred') +
  theme_classic() +
  labs(x="Time (~h)", y="Usage (%)") +
  ggtitle("CPU usage per subject (100% = 1 core)") +
  theme(
    text=element_text(size=18), 
    axis.line = element_line(size = 1), 
    axis.text.x = element_text(size=15,colour="black",
                               angle = 0,
                               vjust = .5, 
                               hjust = 0.5), 
    axis.text.y = element_text(size=15, colour='black'), 
    legend.title = element_blank())

ggsave('./cpu.png', device="png", units="in", width=9.54, height=4.54, dpi=300)   

