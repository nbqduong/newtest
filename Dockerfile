# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: GCC, G++, CMake, and Google Test
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    libgtest-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install GTest and GMock directly
RUN apt-get update && \
    apt-get install -y libgtest-dev libgmock-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /workspace

# Copy the current directory contents into the container
COPY . .

# Build the project: remove existing 'build' folder before building
RUN rm -rf build && \
    cmake -S . -B build -G Ninja && \
    cmake --build build

# Command to run tests
WORKDIR /workspace/build
CMD ["ctest"]

