# Contributor's Guide

Below is our guidance for how to Add Framwork or Developer toolkit, propose new features.


## Add Feature

If you need to add a new feature, just create a new `sh file` and start to implement the feature and it's all dependencies `inside a single file`.

> ⚠️ Notes :
> * Add all dependencies below installation process in the same sh file


- ### Add a new sh file process :

  1. Go to scripts folder 

  ```bash
   cd src/common/scripts
  ```
  2. Create new feature sh file 
  ```bash
  
  touch ${feature_name}_install.sh # feature_name will be your desired feature like `GUI_Display`
 
  ```
  3. Open new file on terminal or on your favourite IDE and start work
   
  ```bash
   # open with vs code
  code -r ${feature_name}_install.sh # open from terminal

  ```


- ### How to Integrate your new installation file in app structure

1. Integrate at docker `Cross-Compilation` in your desired target
    - SEARCH this text `All Sections variance here` inside Dockerfile
    - inside Your desired target section add 

    ```bash
    ADD /src/common/scripts/${feature_name}_install.sh /scripts/${feature_name}_install.sh
    RUN chmod +x scripts/${feature_name}_install.sh

    ```

    - make your script executable by add this line inside `target condition execute`

    ```bash
    # run your sh file here
    ./scripts/${feature_name}_install.sh; \
    ```
2. Integrate for `Full System Installation`
    - Navigate to Your desired target insied `src/targets`
    - open `full_system_installation.sh` file
    - add your file 
    
    ```bash
    chmod +x ../../../src/common/scripts/${feature_name}_install.sh

    ../../../src/common/scripts/${feature_name}_install.sh
    ```