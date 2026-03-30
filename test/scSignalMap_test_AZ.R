# remotes::install_github('A-Zehnder/scSignalMap/scSignalMap')

# remove previous version if necessary
# detach("package:scSignalMap", unload = TRUE)
# remove.packages("scSignalMap")

library(Seurat)
library(dplyr)
library(fastmatch)
library(data.table)
library(scSignalMap)
library(EnsDb.Mmusculus.v79)
library(enrichR)
library(tidyr)
library(stringr)
library(AnnotationDbi)

library(progress)
library(googledrive)

# sender cells
sender_all = c('Endo.','VSMC/Fibro.', 'Mo', 'M inflam.', 'M TremHi', 'DC', 'N', 'T')

# receiver cells
celltypes = c('Endo.', 'VSMC/Fibro.', 'Mo', 'M inflam.', 'M TremHi', 'DC', 'N', 'T')

# example 
result = run_full_scSignalMap_pipeline(
  seurat_obj = seurat_obj, 
  prep_SCT = TRUE, 
  cond_column = 'source', 
  cond_name1 = 'MoNP_VP', 
  cond_name2 = 'MoNP', 
  celltype_column = 'cell_types', 
  celltype_name = celltypes, 
  sender_celltypes = sender_all, 
  receiver_celltypes = celltypes, 
  secreted_lig = TRUE, 
  FC_cutoff = 0.3, 
  adj_p_val_cutoff = 0.05, 
  enrichr_databases = c("BioCarta_2016", "GO_Biological_Process_2025", "KEGG_2019_Mouse", "NCI-Nature_2016", "WikiPathways_2024_Mouse"), 
  adj_p_val_method = "BH", 
  ensdb = 'EnsDb.Mmusculus.v79', 
  species='mouse')


run_post_processing_Neo4J(
    all_results = result,
    neo4j_prefix = "scSignalMap",
    dataset_name = "MoNP_VP",
    generate_local_script = FALSE,
    generate_cloud_script = FALSE,
    file_urls = NULL,
    use_google_drive = TRUE,
    google_drive_folder_name = "Test_2_Neo4J_MoNP_VP",
    output_dir = "Neo4J/MoNP_VP/"
)

