//
//  CCWeatherForecastTVC.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import UIKit

class CCWeatherForecastTVC: CCBaseTVC {

    @IBOutlet private weak var m_dayLabel: UILabel!
    @IBOutlet private weak var m_temperatureLabel: UILabel!
    @IBOutlet weak var m_containerView: UIView!
    @IBOutlet weak var m_weatherImg: UIImageView!

    private var m_cellModel: CCWeatherForecastCellModel?

    override func configure(with data: Any, at pos: Int) {
        super.configure(with: data, at: pos)
        m_cellModel = data as? CCWeatherForecastCellModel
        setupViews()
    }

    private func setupViews() {
        guard let model = m_cellModel else { return }
        m_containerView.layer.cornerRadius = 10
        m_containerView.layer.masksToBounds = true
        m_dayLabel.text = model.m_dayName
        m_temperatureLabel.text = model.m_temperature
        m_weatherImg.image = getWeatherIcon(for: model.m_weatherCondition, description: model.m_weatherDescription)
        m_weatherImg.contentMode = .scaleAspectFit
        configureLabelStyles()
    }

    private func getWeatherIcon(for condition: String, description: String) -> UIImage? {
        let lowercasedDescription = description.lowercased()

        if lowercasedDescription.contains("thunderstorm") || lowercasedDescription.contains("thunder") {
            return UIImage(named: WeatherIcon.thunderstorm.rawValue)
        } else if lowercasedDescription.contains("heavy rain") {
            return UIImage(named: WeatherIcon.heavyRain.rawValue)
        } else if lowercasedDescription.contains("snow") || lowercasedDescription.contains("snowfall") {
            if lowercasedDescription.contains("heavy") {
                return UIImage(named: WeatherIcon.heavySnowfall.rawValue)
            }
            return UIImage(named: WeatherIcon.snow.rawValue)
        } else if lowercasedDescription.contains("hail") {
            return UIImage(named: WeatherIcon.hailstorm.rawValue)
        }

        switch condition.lowercased() {
        case "clear":
            return UIImage(named: WeatherIcon.sun.rawValue)
        case "clouds":
            if lowercasedDescription.contains("few") || lowercasedDescription.contains("scattered") {
                return UIImage(named: WeatherIcon.partialCloudy.rawValue)
            } else if lowercasedDescription.contains("mostly") || lowercasedDescription.contains("overcast") {
                return UIImage(named: WeatherIcon.mostlyCloudy.rawValue)
            }
            return UIImage(named: WeatherIcon.cloud.rawValue)
        case "rain":
            if lowercasedDescription.contains("drizzle") || lowercasedDescription.contains("light") {
                return UIImage(named: WeatherIcon.drop.rawValue)
            }
            return UIImage(named: WeatherIcon.rain.rawValue)
        case "drizzle":
            return UIImage(named: WeatherIcon.drop.rawValue)
        case "snow":
            return UIImage(named: WeatherIcon.snow.rawValue)
        case "mist", "fog", "haze", "smoke":
            return UIImage(named: WeatherIcon.mostlyCloud.rawValue)
        default:
            return UIImage(named: WeatherIcon.cloud.rawValue)
        }
    }

    private func configureLabelStyles() {
        m_dayLabel.font = .poppinsSemiBold(size: 16)
        m_dayLabel.textColor = .label
        m_temperatureLabel.font = .poppinsBold(size: 36)
        m_temperatureLabel.textColor = .label
        contentView.backgroundColor = .clear
    }

    override func setupCellUI() {
        super.setupCellUI()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        m_weatherImg.contentMode = .scaleAspectFit
        m_weatherImg.tintColor = .label
    }
}

