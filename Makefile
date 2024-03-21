NVCC = /usr/local/cuda-11.8/bin/nvcc
NVCC_FLAGS = -std=c++11 -arch=sm_86 -lineinfo -lcublas -lcusparse -I${SPUTNIK_PATH}


##################################################################

## Project file structure ##

# Source file directory:
SRC_DIR = src

# Object file directory:
OBJ_DIR = bin

# Include header file directory
INC_DIR = include

# Library directory
LIB_DIR = ${SPUTNIK_PATH}

##################################################################

## Compile ##

sddmm_benchmark: $(OBJ_DIR)/sddmm_benchmark.o $(OBJ_DIR)/cuda_sddmm.o $(OBJ_DIR)/wmma_sddmm.o $(OBJ_DIR)/cublas_gemm.o
	@$(NVCC) $(NVCC_FLAGS) $(LIB_DIR)/libsputnik.so $^ -o $@

spmm_benchmark: $(OBJ_DIR)/spmm_benchmark.o $(OBJ_DIR)/cuda_spmm.o $(OBJ_DIR)/wmma_spmm.o $(OBJ_DIR)/cublas_gemm.o
	@$(NVCC) $(NVCC_FLAGS) $(LIB_DIR)/libsputnik.so $^  -o $@

# Compile main file to object file
$(OBJ_DIR)/%.o : %.cpp
	@$(NVCC) $(NVCC_FLAGS) -x c++ -c $< -o $@ 


# Compile CUDA source files to object files
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cu $(INC_DIR)/%.cuh
	@$(NVCC) $(NVCC_FLAGS) -x cu -c $< -o $@

clean:
	@rm -f $(OBJ_DIR)/*.o