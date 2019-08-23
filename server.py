#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
# from os import system
import os.path
import subprocess
import glob, os
message = "GET"

def compile_java(java_file):
	filePart = java_file.split('.')[0]
	output = os.popen('javac ' + java_file + ' && java ' + filePart + ' && del ' + filePart + '.class').read()
	return output

def getChallenge(challenge):
	global challengePack
	file = open(challengePack, 'r')
	fileData = file.read()
	return fileData.split('\n')[challenge - 2 + challenge].replace('*newline*','\n')

def getSolution(challenge):
	global challengePack
	file = open(challengePack, 'r')
	fileData = file.read()
	return fileData.split('\n')[challenge - 1 + challenge].replace('*newline*','\n')

def addPlayer(player):
	file = open("players.conf","a+")
	file.write(player + "| 1\n")
	file.close

def getPlayers():
	file = open("players.conf", "r+")
	fileData = file.read()
	file.close()
	output = []
	for x in fileData.split('\n'):
		output.append(x.split('|')[0])
		if len(x) >= 2:
			output.append(x.split('|')[1])
	return output

def getPlayerProgress(player):
	i = 0
	while i < len(getPlayers()):
		if getPlayers()[i] == player:
			index = i + 1
		i += 1
	return int(getPlayers()[index])

def addPlayerProgress(player):
	global challengePack
	file = open(challengePack, 'r')
	fileData = file.read()
	max = len(fileData.split('\n'))
	if getPlayerProgress(player) >= max / 2:
		return "Win"
	
	i = 0
	while i < len(getPlayers()):
		if getPlayers()[i] == player:
			index = i + 1
		i += 1
	
	output = []
	i = 0
	while i < len(getPlayers()):
		if i == index:
			output.append(int(getPlayers()[i]) + 1)
		else:
			output.append(getPlayers()[i])
		i += 1
	
	finalOutput = ""
	i = 0
	while i < len(output) / 2:
		finalOutput = finalOutput + str(output[i]) + "| " + str(output[i + 1]) + "\n"
		i += 2
	file = open('players.conf', 'w+')
	file.write(finalOutput)
	file.close()
	

def process(inputData):
	parsedData = inputData.split('|')
	if not parsedData[0] in getPlayers():
		addPlayer(parsedData[0])
		print("	~" + parsedData[0] + ' has joined!')
		return getChallenge(1)
	elif parsedData[1] == "GetFile":
		return getChallenge(getPlayerProgress(parsedData[0]))
	elif parsedData[1] == "Submit":
		file = open(getChallenge(getPlayerProgress(parsedData[0])).split('*name*')[0] + '.java', "w+")
		file.write(parsedData[2].replace('*newline*', '\n').replace('*tab*', '	'))
		file.close()
		if compile_java(getChallenge(getPlayerProgress(parsedData[0])).split('*name*')[0] + '.java') == getSolution(getPlayerProgress(parsedData[0])).replace('*newline*', '\n'):
			if addPlayerProgress(parsedData[0]) == "Win":
				global message
				message = parsedData[0] + " wins!"
				print("    ~" + parsedData[0] + " wins!")
				return "Win"
		else:
			return "Fail"
	print('Invalid input: ' + str(parsedData))
	return 'Error'

class S(BaseHTTPRequestHandler):
	def _set_response(self):
		self.send_response(200)
		self.send_header('Content-type', 'text/html')
		self.end_headers()

	def do_GET(self):
		global message
		self._set_response()
		self.wfile.write(message.encode('utf-8'))

	def do_POST(self):
		content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
		post_data = self.rfile.read(content_length) # <--- Gets the data itself
		
		# Responds after processing the input data
		response = process(str(post_data)[2:-1])
		self._set_response()
		self.wfile.write(response.encode('utf-8'))
		print(str(post_data)[2:-1])


def run(server_class=HTTPServer, handler_class=S):
	global challengePack
	challengePacks = glob.glob("*.chp")
	if len(challengePacks) != 1:
		if len(challengePacks) > 1:
			i = 1
			for x in challengePacks:
				print("(" + str(i) + ") " + str(x))
				i += 1
			choice = int(input("Pick a file: "))
			i = 1
			for x in challengePacks:
				if i == choice:
					challengePack = x
					os.system('cls')
					os.system('title Coding Royale Server')
					print("Challenge pack: " + challengePack)
				i += 1
		else:
			print('Please move a challenge pack (.chp) to the current directory')
			input("Press Enter to continue...")
			exit()
	else:
		challengePack = challengePacks[0]
		os.system('cls')
		os.system('title Coding Royale Server')
		print("Challenge pack: " + challengePack)
	httpd = server_class(('', 80), handler_class)
	file = open("players.conf","w+")
	file.write("")
	file.close()
	try:
		httpd.serve_forever()
	except KeyboardInterrupt:
		pass
	os.remove("players.conf")
	httpd.server_close()

if __name__ == '__main__':
	run()
