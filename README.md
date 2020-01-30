# Lifespan automation demo:
Lifespan automation for *C. elegans* cultured in standard Petri plates is a challenging problem because Petri plate edges present occlusions, worms can be aggregated, plates might accumulate dirt contamination (dust spots on the lid) during assays, and so on. This project presents two image-processing pipelines applied to different plate zones and a new data post-process method to solve these problems. 

# Requirements:
This demo was tested in Windows 10 with Matlab R2018b and Java V8 update 241
- Windows 10
- Matlab R2018b
- Java V8 update 241

# Clone lifespan repository:
```
git clone https://github.com/AntonioJoseSanchezSalmeron/lifespan.git
```

# Windows x64 installation:
Run ```install.bat```

# Download lifespan example (Lifespan18):
- [Lifespan18.zip (8.53 GB)](https://active-vision.ai2.upv.es/wp-content/uploads/2020/01/Lifespan18.zip)
- Uncompress Lifespan18.zip
- Move uncompressed Lifespan18 folder into lifespan folder before running the demo.

# Run Lifespan18 demo in Matlab:
Run ```lifespan.m``` macro

# Download Lifespan18 annotated results:
- [Lifespan18_Results.zip (0.17 GB)](https://active-vision.ai2.upv.es/wp-content/uploads/2020/01/Lifespan18_Results.zip)
- Results include the manual annotated alive *C. elegans*

# Image adquisition system:
- Images were captured by an [open hardware system](https://github.com/JCPuchalt/c-elegans_smartLight).

# References:
- Puchalt, J. C., Sánchez-Salmerón, A.-J., Martorell Guerola, P. & Genovés Martínez, S. "Active backlight for automating visual monitoring: An analysis of a lighting control technique for *Caenorhabditis elegans* cultured on standard Petri plates". PLOS ONE 14.4 (2019)