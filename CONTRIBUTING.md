# Contributor's Guide

Below is our guidance for how to Add Framwork or Developer toolkit, propose new features.


## Add Framwork or Developer toolkit

If you need to add a new framwork like `ros` or add any dev toolkit , you just create a new sh file and start to implement what you need.

- ### Add a new sh installation process :

  1. Go to scripts folder 

  ```bash
   cd src/common/scripts
  ```
  2. Create new tool sh file 
  ```bash
  
  touch ${toolname}_install.sh # toolname will be your desired toolkit like `qt` or `vcpkg`
 
  ```
  3. Open new file on terminal or on your favourite IDE and start work
   
  ```bash
   # open with vs code
  code -r ${toolname}_install.sh # open from terminal

  ```


- ### How to Integrate your new installation file in app structure

1. Integrate for `Cross-Compilation` in your desired target
    - SEARCH this text `All Sections variance here` inside Dockerfile
    - inside Your desired target section add 

    ```bash
    ADD /src/common/scripts/${toolname}_install.sh /scripts/${toolname}_install.sh
    RUN chmod +x scripts/${toolname}_install.sh

    ```

    - make your script excutable by add this line inside `target condition excute`

    ```bash
    # run your sh file here
    ./scripts/${toolname}_install.sh; \
    ```
2. Integrate for `Full System Installation`
    - Navigate to Your desired target insied `src/targets`
    - open `full_system_installation.sh` file
    - add your file 
    
    ```bash
    chmod +x ../../src/common/scripts/${toolname}_install.sh

    ../../src/common/scripts/${toolname}_install.sh
    ```


## Add Dependency

All needed dependencies , packages and plugings can be added inside `dependencies_install.sh` file at `src/common/scripts` directory