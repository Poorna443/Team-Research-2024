# Load necessary libraries
library(tidyverse)
library(ggplot2)

# Read the dataset
AMD_Database <- read_csv("amd(database).csv", show_col_types = FALSE)

# Print Column Names
colnames(AMD_Database)

# Renaming columns for easy analysis
AMD_Database <- AMD_Database %>% rename(
  model = Model,
  family = Family,
  line = Line,
  platform = Platform,
  launch_date = `Launch Date`,
  cpu_cores = `# of CPU Cores`,
  threads = `# of Threads`,
  gpu_cores = `# of GPU Cores`,
  compute_cores = `Compute Cores`,
  base_clock = `Base Clock`,
  max_boost_clock = `Max Boost Clock`,
  all_core_boost_speed = `All Core Boost Speed`,
  total_l1_cache = `Total L1 Cache`,
  total_l2_cache = `Total L2 Cache`,
  total_l3_cache = `Total L3 Cache`,
  unlocked = Unlocked,
  cmos = CMOS,
  package = Package,
  socket_count = `Socket Count`,
  pci_express_version = `PCI Express® Version AMD EPYC™ 7002 Series`,
  thermal_solution_pib = `Thermal Solution PIB`,
  default_tdp = `Default TDP / TDP AMD EPYC™ 7002 Series`,
  ctdp = cTDP,
  max_temps = `Max Temps`,
  system_memory_spec = `System Memory Specification AMD EPYC™ 7002 Series`,
  system_memory_type = `System Memory Type`,
  memory_channels = `Memory Channels`,
  per_socket_mem_bw = `Per Socket Mem BW`,
  graphics_frequency = `Graphics Frequency`,
  gpu_base = `GPU Base`,
  graphics_model = `Graphics Model`,
  graphics_core_count = `Graphics Core Count`,
  displayport = DisplayPort,
  hdmi = HDMI,
  dvi = DVI,
  vga = VGA)

# Print head of the AMD_Database
head(AMD_Database)

# Print tail of the AMD_Database
tail(AMD_Database)

# Check missing values in the AMD_Database
colSums(is.na(AMD_Database))

# Print total missing values in the AMD_Database
sum(is.na(AMD_Database))

# Remove columns with more than 50% missing values
threshold <- 0.5 * nrow(AMD_Database)
AMD_Database <- AMD_Database %>% select(where(~ sum(is.na(.)) < threshold))

# Print column names after removing columns with too many missing values
colnames(AMD_Database)

# Fill remaining missing values with specific values ensuring to match column types
AMD_Database <- AMD_Database %>% replace_na(list(
  platform = "Unknown",
  launch_date = "Unknown",
  cpu_cores = 0,
  threads = 0,
  gpu_cores = 0,
  compute_cores = "Unknown",
  base_clock = "0",
  max_boost_clock = "0",
  all_core_boost_speed = "0",
  total_l1_cache = "0",
  total_l2_cache = "0",
  total_l3_cache = "0",
  unlocked = "No",
  cmos = "Unknown",
  package = "Unknown",
  socket_count = "0",
  pci_express_version = "Unknown",
  thermal_solution_pib = "Unknown",
  default_tdp = "0",
  ctdp = "0",
  max_temps = "0",
  system_memory_spec = "Unknown",
  system_memory_type = "Unknown",
  memory_channels = 0,
  per_socket_mem_bw = "0",
  graphics_frequency = "0",
  gpu_base = "0",
  graphics_model = "Unknown",
  graphics_core_count = 0,
  displayport = "Unknown",
  hdmi = "Unknown"
))

# Check if all missing values are filled
colSums(is.na(AMD_Database))

# Print structure of the AMD_Database
str(AMD_Database)

# Converting the family and cpu_cores columns in the correct format
AMD_Database <- AMD_Database %>%
  mutate(cpu_cores = as.numeric(cpu_cores))

# Combined histogram diagram for AMD A-Series and AMD Ryzen Processors
ggplot(AMD_Database %>% filter(family %in% c("AMD A-Series Processors", "AMD Ryzen™ Processors")), aes(x = cpu_cores, fill = family)) +
  geom_histogram(aes(y = ..density..), binwidth = 1, color = "black", alpha = 0.7, position = "identity") +
  geom_density(aes(y = ..density.., color = family), size = 1) +
  labs(title = "Histogram of CPU Cores in AMD Processors", x = "Number of CPU Cores", y = "Density") +
  theme_minimal()

# Box plot diagram comparing CPU cores between AMD A-Series and AMD Ryzen Processors
ggplot(AMD_Database %>% filter(family %in% c("AMD A-Series Processors", "AMD Ryzen™ Processors")), aes(x = family, y = cpu_cores, fill = family)) +
  geom_boxplot(alpha = 0.7, notch = TRUE, varwidth = TRUE) +
  labs(title = "Box Plot of CPU Cores by Processor Family", x = "Processor Family", y = "Number of CPU Cores") +
  theme_minimal()

# Perform t-test to compare the means of CPU cores between the two families
AMD_A_Series <- AMD_Database %>% filter(family == "AMD A-Series Processors") %>% pull(cpu_cores)
AMD_Ryzen <- AMD_Database %>% filter(family == "AMD Ryzen™ Processors") %>% pull(cpu_cores)

TTestCPU <- t.test(AMD_A_Series, AMD_Ryzen)
print(TTestCPU)
