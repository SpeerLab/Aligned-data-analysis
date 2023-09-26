# Aligned-data-analysis
MATLAB scripts to extract data from aligned STORM images. 

Results for the application have been published in [Cell Reports](https://www.cell.com/cell-reports/fulltext/S2211-1247(23)00096-7?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS2211124723000967%3Fshowall%3Dtrue). 

## Image data struction
The scripts are designed for 3-color STORM image processing. The image stack should be aligned before the processing. 

STORM images should be stored in 'elastic_align' folder, where super-resoltuion data is stored in 'elastic_align/storm_merged' and corresponding conventional data is stored in 'elastic_align/conv_merged'. 

In this example, presynaptic data (Bassoon) is in the red channel, postsynaptic data (Homer1/2/3) is in the green channel, and vesicle pool data (VGluT2) is in the blue channel. 

Before running the scripts, make sure './additional_matlab_functions/' has been added to MATLAB path environment. 

## 1_Soma_out: 
* Soma_Green_Storm.m
Filter out unspecific labeling in soma. It will also save image area with or without(neuropil) the soma region. 

## 2_Synapse: 
* Identify_Synapse_R.m and Identify_Synapse_G.m
Find connected components of synaptic clusters in the red and green channels. Details about the heatmap cluster selection can be found in [this publication](https://pubmed.ncbi.nlm.nih.gov/26435106/).
*Add_to_G.m and Add_to_R.m
Find red clusters that are close to green clusters and vice versa.Use the following line to change the search radius:
```matlab
size2= 140; %Unit: nm. 
curr3b = Dg<=(size2); curr4b = or(curr2,curr3b);
[y,x,z] = ind2sub(size(curr4b),find(curr4b));
PixelList_m140 = [x,y,z]; %m140 in the variable name indicates the searching radius
```
* Identify_Synpase_pairing.m
Select paired pre- and post- synaptic clusters based on their distance to cluster in another channel. It includes an [OPTICS](https://dl.acm.org/doi/10.1145/304181.304187) method for cluster identification, which requres customization for different datasets.
* Add_to.m and Large_Cluster.m
These scripts are optional. They filter out large clusters (composing more than 5 clusters from each channel) that are more likely to be artefacts. 


## 3_VGLuT2: 
Scripts here are similar to those in '2_Synapse', it pair clusters in the red channel to the blue channel(vesicle pools) and further find green clusters that are paired with these two. Run the following files in order:
* Identify_Synapse_V.m 
* Add_to_V.m 
* Identify_Synpase_pairing.m
* Synapse_Divide_Add_to.m and Synapse_Divide.m
* Synapse_Divide_G_add_to.m' and Synapse_divide_G.m.

## 4_CTB: 
Similar to scripts in '3_VGluT2'. They pair blue (vesicle pool) clusters with CTB clusters. CTB signals are stored in 'elastic_align\storm_561_488\' rather than 'elastic_align\storm_merged\'. Run the following scripts in order: 
* Identify_CTB_Conv.m
* V_addto_C.m
* V_pairing.m
* R_Add_To_V.m and RV_pairing.m
* G_add_To_RVC.m and GV_pairing.m

## 5_Syn_to_C
Pair Bassoon (red) clusters directly to CTB signals. The script structure is similar to step 3 or 4. 

## 6_Bassoon_Shel
Scripts for shell analysis published in [this paper](https://www.cell.com/cell-reports/fulltext/S2211-1247(23)00096-7?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS2211124723000967%3Fshowall%3Dtrue). 
* B_add_to_V_CTB.m: core analysis.
* B_add_to_V_normalize.m: similar to core analysis but cluster size is normalized to Bassoon clusters.
* Find_Null.m, Get_Bassoon_Size.m, and Illustrating.m: tools.
* Other files are used for testing purpose.

## 7_Two_Peak_Fitting
Divide VGluT2 clsuters into 2 pupolations based on their size. 
* Fitting.m: core. Splitting VGLuT2 clusters.
* Fitting_SSD.m: Splitting Bassoon/Homer1 SSD populations.
* Example_Get.m: figure rendering. 

## Use 'Render_cluster.m' as a tool to render connected components as images. 
