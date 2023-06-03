import json
import os
import zipfile
from ruamel.std.zipfile import InMemoryZipFile
from shutil import copyfile

import dateutil.parser

sourceFile = os.getcwd() + "\..\source\[NAWDC]RedTide v0_40.miz"

weatherFile = os.getcwd() + "\..\config\weather.json"


def DecodeDateTime(empDict):
	if 'date' in empDict:
		empDict["date"] = dateutil.parser.parse(empDict["date"])
		return empDict
	return empDict


if os.path.exists(weatherFile) and os.path.isfile(weatherFile):
	file = open(weatherFile, mode='r')
	with open(weatherFile, mode='r') as jFile:
		weathers = json.load(jFile, object_hook=DecodeDateTime)

	for weather in weathers:
		print("Processing mission: " + weather["name"])

		append = weather["name"].lower()
		if append == "a":
			append = ""

		targetFile = "../output/[NAWDC]RedTide v0_40" + append + ".miz"
		copyfile(sourceFile, targetFile)

		zip = zipfile.ZipFile(targetFile, "a", zipfile.ZIP_DEFLATED, False)
		with zip.open("mission") as mFile:
			fileSource = str(mFile.read())

		startWeather = None
		endWeather = None
		startDate = None
		startTime = None

		lines = fileSource.split("\\n")
		for index, line in enumerate(lines):
			if "[\"weather\"] =" in line:
				startWeather = index
			elif line.__contains__("}, -- end of [\"weather\"]"):
				endWeather = index
			elif line.__contains__("[\"date\"] ="):
				startDate = index
			elif len(line) > 20:
				if line[:20].__contains__("[\"start_time\"] ="):
					startTime = index

		weatherLines = lines[startWeather:endWeather]
		for i, line in enumerate(weatherLines):
			if "[\"at8000\"]" in line and "end of" not in line:
				lines[i + startWeather + 2] = "\t\t\t\t[\"speed\"] = " + "{:.4f}".format(
					weather["weather"]["wind"]["at8000"]["speed"]) + ","
				lines[i + startWeather + 3] = "\t\t\t\t[\"dir\"] = " + "{:.0f}".format(
					weather["weather"]["wind"]["at8000"]["dir"]) + ","
			if "[\"at2000\"]" in line and "end of" not in line:
				lines[i + startWeather + 2] = "\t\t\t\t[\"speed\"] = " + "{:.4f}".format(
					weather["weather"]["wind"]["at2000"]["speed"]) + ","
				lines[i + startWeather + 3] = "\t\t\t\t[\"dir\"] = " + "{:.0f}".format(
					weather["weather"]["wind"]["at2000"]["dir"]) + ","
			if "[\"atGround\"]" in line and "end of" not in line:
				lines[i + startWeather + 2] = "\t\t\t\t[\"speed\"] = " + "{:.4f}".format(
					weather["weather"]["wind"]["atGround"]["speed"]) + ","
				lines[i + startWeather + 3] = "\t\t\t\t[\"dir\"] = " + "{:.0f}".format(
					weather["weather"]["wind"]["atGround"]["dir"]) + ","
			if "[\"groundTurbulence\"]" in line:
				lines[i + startWeather] = "\t\t[\"groundTurbulence\"] = " + "{:.3f}".format(
					weather["weather"]["groundTurbulence"]) + ","
			if "[\"temperature\"]" in line:
				lines[i + startWeather] = "\t\t\t[\"temperature\"] = " + "{:.3f}".format(
					weather["weather"]["season"]["temperature"]) + ","
			if "[\"qnh\"]" in line:
				lines[i + startWeather] = "\t\t[\"qnh\"] = " + "{:.0f}".format(
					weather["weather"]["qnh"]) + ","
			if "[\"fog\"]" in line and "end of" not in line:
				lines[i + startWeather + 2] = "\t\t\t[\"thickness\"] = " + "{:.0f}".format(
					weather["weather"]["fog"]["thickness"]) + ","
				lines[i + startWeather + 3] = "\t\t\t[\"visibility\"] = " + "{:.0f}".format(
					weather["weather"]["fog"]["visibility"]) + ","
			if "[\"enable_fog\"]" in line:
				lines[i + startWeather] = "\t\t[\"enable_fog\"] = " + (
					"true" if weather["weather"]["enable_fog"] else "false") + ","
			if "[\"dust_density\"]" in line:
				lines[i + startWeather] = "\t\t[\"dust_density\"] = " + "{:.0f}".format(
					weather["weather"]["dust_density"]) + ","
			if "[\"enable_dust\"]" in line:
				lines[i + startWeather] = "\t\t[\"enable_dust\"] = " + (
					"true" if weather["weather"]["enable_dust"] else "false") + ","
			if "[\"clouds\"]" in line and "end of" not in line:
				lines[i + startWeather + 2] = "\t\t\t[\"thickness\"] = " + "{:.0f}".format(
					weather["weather"]["clouds"]["thickness"]) + ","
				lines[i + startWeather + 3] = "\t\t\t[\"density\"] = " + "{:.0f}".format(
					weather["weather"]["clouds"]["density"]) + ","
				lines[i + startWeather + 4] = "\t\t\t[\"preset\"] = " + weather["weather"]["clouds"]["preset"] + ","
				lines[i + startWeather + 5] = "\t\t\t[\"base\"] = " + "{:.0f}".format(
					weather["weather"]["clouds"]["base"]) + ","
				lines[i + startWeather + 6] = "\t\t\t[\"iprecptns\"] = " + "{:.0f}".format(
					weather["weather"]["clouds"]["iprecptns"]) + ","

		lines[startDate + 2] = "\t\t[\"Year\"] = " + "{:.0f}".format(weather["date"].year) + ","
		lines[startDate + 3] = "\t\t[\"Day\"] = " + "{:.0f}".format(weather["date"].day) + ","
		lines[startDate + 4] = "\t\t[\"Month\"] = " + "{:.0f}".format(weather["date"].month) + ","

		parsedTime = ((weather["date"].hour * 60) + weather["date"].minute) * 60 + weather["date"].second
		lines[startTime] = "\t[\"start_time\"] = " + "{:.0f}".format(parsedTime) + ","

		fileSource = "\n".join(lines)

		mizfilehandle = InMemoryZipFile(targetFile)
		mizfilehandle.delete_from_zip_file(None, 'mission')
		mizfilehandle.append('mission', fileSource)
		mizfilehandle.write_to_file(targetFile)
