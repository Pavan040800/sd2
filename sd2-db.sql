-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 19, 2025 at 12:06 PM
-- Server version: 8.2.0
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sd2-db`
--

-- --------------------------------------------------------

--
-- Table structure for table `Donations`
--

CREATE TABLE `Donations` (
  `donation_id` int NOT NULL,
  `restaurant_id` int NOT NULL,
  `food_description` text NOT NULL,
  `quantity` int NOT NULL,
  `charity_name` varchar(255) DEFAULT NULL,
  `donation_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Donations`
--

INSERT INTO `Donations` (`donation_id`, `restaurant_id`, `food_description`, `quantity`, `charity_name`, `donation_time`) VALUES
(1, 1, 'Dal & Rice Meals', 10, 'Annapurna Food Bank', '2025-03-19 11:05:37'),
(2, 2, 'Leftover Rotis & Sabzi', 15, 'Robin Hood Army', '2025-03-19 11:05:37'),
(3, 3, 'Veg Thali Meals', 20, 'Akshaya Patra Foundation', '2025-03-19 11:05:37'),
(4, 4, 'Cooked Rice & Curry', 25, 'ISKCON Food Relief', '2025-03-19 11:05:37'),
(5, 5, 'Snacks & Sweets', 30, 'Seva Bharati', '2025-03-19 11:05:37');

-- --------------------------------------------------------

--
-- Table structure for table `FoodItems`
--

CREATE TABLE `FoodItems` (
  `item_id` int NOT NULL,
  `restaurant_id` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `quantity` int DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `status` enum('available','donated') DEFAULT 'available',
  `donation_status` enum('none','donated') DEFAULT 'none',
  `donation_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `FoodItems`
--

INSERT INTO `FoodItems` (`item_id`, `restaurant_id`, `name`, `description`, `quantity`, `expiry_date`, `status`, `donation_status`, `donation_date`) VALUES
(1, 1, 'Paneer Butter Masala', 'Delicious paneer cooked in creamy tomato gravy', 10, '2025-03-21', 'available', 'none', NULL),
(2, 2, 'Masala Dosa', 'Crispy dosa stuffed with spicy potato filling', 5, '2025-03-20', 'available', 'none', NULL),
(3, 3, 'Gujarati Thali', 'Complete traditional Gujarati meal', 2, '2025-03-22', 'available', 'none', NULL),
(4, 4, 'Chicken Biryani', 'Aromatic basmati rice cooked with spices and chicken', 1, '2025-03-21', 'available', 'none', NULL),
(5, 5, 'Dal Baati Churma', 'Famous Rajasthani dish with ghee-soaked baati', 2, '2025-03-23', 'available', 'none', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Restaurants`
--

CREATE TABLE `Restaurants` (
  `restaurant_id` int NOT NULL,
  `owner_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `location` text NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Restaurants`
--

INSERT INTO `Restaurants` (`restaurant_id`, `owner_id`, `name`, `location`, `contact_number`, `rating`, `created_at`) VALUES
(1, 3, 'Patel Dhaba', 'Ahmedabad, Gujarat', '9823123456', 4.50, '2025-03-19 11:05:34'),
(2, 4, 'Sharma’s Kitchen', 'Bangalore, Karnataka', '9812346789', 4.70, '2025-03-19 11:05:34'),
(3, 3, 'Gujju Thali', 'Surat, Gujarat', '9900123456', 4.20, '2025-03-19 11:05:34'),
(4, 4, 'South Spice', 'Chennai, Tamil Nadu', '9786543210', 4.80, '2025-03-19 11:05:34'),
(5, 5, 'Rajasthani Rasoi', 'Jaipur, Rajasthan', '9945678901', 4.60, '2025-03-19 11:05:34');

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE `Users` (
  `user_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address` text,
  `user_type` enum('customer','restaurant_owner','admin') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`user_id`, `name`, `email`, `password_hash`, `phone_number`, `address`, `user_type`, `created_at`) VALUES
(1, 'Rajesh Kumar', 'rajesh.kumar@example.com', 'hashed_password_1', '9876543210', 'Mumbai, Maharashtra', 'customer', '2025-03-19 11:05:34'),
(2, 'Sneha Verma', 'sneha.verma@example.com', 'hashed_password_2', '9823456789', 'Delhi, India', 'customer', '2025-03-19 11:05:34'),
(3, 'Vikram Patel', 'vikram.patel@example.com', 'hashed_password_3', '9765432101', 'Ahmedabad, Gujarat', 'restaurant_owner', '2025-03-19 11:05:34'),
(4, 'Priya Sharma', 'priya.sharma@example.com', 'hashed_password_4', '9812345678', 'Bangalore, Karnataka', 'restaurant_owner', '2025-03-19 11:05:34'),
(5, 'Amit Tiwari', 'amit.tiwari@example.com', 'hashed_password_5', '9934567890', 'Chennai, Tamil Nadu', 'admin', '2025-03-19 11:05:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Donations`
--
ALTER TABLE `Donations`
  ADD PRIMARY KEY (`donation_id`),
  ADD KEY `restaurant_id` (`restaurant_id`);

--
-- Indexes for table `FoodItems`
--
ALTER TABLE `FoodItems`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `restaurant_id` (`restaurant_id`);

--
-- Indexes for table `Restaurants`
--
ALTER TABLE `Restaurants`
  ADD PRIMARY KEY (`restaurant_id`),
  ADD KEY `owner_id` (`owner_id`);

--
-- Indexes for table `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Donations`
--
ALTER TABLE `Donations`
  MODIFY `donation_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `FoodItems`
--
ALTER TABLE `FoodItems`
  MODIFY `item_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Donations`
--
ALTER TABLE `Donations`
  ADD CONSTRAINT `Donations_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`) ON DELETE CASCADE;

--
-- Constraints for table `FoodItems`
--
ALTER TABLE `FoodItems`
  ADD CONSTRAINT `FoodItems_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`) ON DELETE CASCADE;

--
-- Constraints for table `Restaurants`
--
ALTER TABLE `Restaurants`
  ADD CONSTRAINT `Restaurants_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `Users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
