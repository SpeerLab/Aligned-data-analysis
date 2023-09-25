# Aligned-data-analysis
MATLAB code to extract data from aligned STORM images. 

Results for the application have been published in [Cell Reports](https://www.cell.com/cell-reports/fulltext/S2211-1247(23)00096-7?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS2211124723000967%3Fshowall%3Dtrue). 

1_Soma_out: 
Run 'Soma_Green_Storm' to filter out unspecific labeling in soma. It will also save image area with or without the soma region. 

2_Synapse: 
Run 'Identify_Synapse_R.m' and 'Identify_Synapse_G.m' to find connected components of synaptic clusters (red and green channel in STORM). 
Run 'Add_to_G.m' and 'Add_to_R.m' to find red clusters close to green ones and vice versa. 
Run 'Identify_Synpase_pairing.m' to find paired green and red clusters. 
Run 'Add_to.m' and 'Large_Cluster.m' to get rid of large unspecific labeling. 

3_VGLuT2: 
The files here are similar to '2_Synapse', it pair clusters in the red channel to the blue channel and further find green clusters that are paired with these two. 
Run 'Identify_Synapse_V.m' - 'Add_to_V.m' - 'Identify_Synpase_pairing.m' - 'Synapse_Divide_Add_to.m' - 'Synapse_Divide.m' - 'Synapse_Divide_G_add_to.m' - 'Synapse_divide_G.m'. 

4_CTB: 
Similar to the previous files but for CTB cluster processing. 

Use 'Render_cluster.m' to render connected components as images. 
