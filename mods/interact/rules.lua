interact.languages = {
	en = "English",
	fr = "Français"
}
--The actual rules.
interact.rules = {
	en = [[1) No intentional try to disturb the server's stability will be tolerated. (lag, crash, bug exploit, ...)
2) Please do not spam or flood.
3) Each player is responsible of his/her own account, we can't be held liable for any illegitimate use of it.
4) Try to avoid 1x1 towers.
5) Grief is allowed if the area isn't protected.
6) Swearing, racism, hate speech and the like is strictly prohibited.

Click on the "I accept" button to get the permission to build and interact with the server.]],
	fr = [[1) Aucune atteinte intentionnelle au bon fonctionnement du serveur ne sera admise. (lag, crash, exploit de bug, etc...)
2) Merci de ne pas spammer ou flooder.
3) Chaque joueur a l'entiere responsabilite de son compte, nous ne sommes en aucun cas responsable d'une utilisation frauduleuse de votre compte dans le jeu.
4) Si possible, evitez les constructions de tours en 1x1.
5) Le grief est autorise si la zone n'est pas protégée.
6) Aucune forme d'insulte ou de racisme n'est admise.

Cliquez sur le bouton "Accepter" pour pouvoir construire et interagir sur le serveur.]]
}

--The questions on the rules, if the quiz is used.
--The checkboxes for the first 4 questions are in config.lua
interact.s4_question1 = {
	en = "Can I use a bug to crash the server so it restarts?",
	fr = "Puis-je utiliser un bug pour faire crasher le serveur afin qu'il redémarre ?"
}
--interact.s4_question2 = {
--	en = "Can I ask to be a member of the staff?",
--	fr = "Puis-je demander à faire partie de l'équipe d'administration?"
--}
--interact.s4_question3 = {
--	en = "Am I alllowed to grief a non-protected zone?",
--	fr = "Ai-je le droit de grieffer une zone non-protégée?"
--}
--interact.s4_question4 = {
--	en = "Can I freely join the IRC channel?",
--	fr = "Puis-je joindre librement l'IRC?"
--}
interact.s4_multi_question = {
	en = "Which of these is a rule?",
	fr = "Laquelle des affirmations est une règle?"
}

--The answers to the multiple choice questions. Only one of these should be true.
interact.s4_multi1 = {
	en = "Prohibition of eating frogs",
	fr = "Interdiction de manger des grenouilles"
}
interact.s4_multi2 = {
	en = "Prohibition of killing unicorns",
	fr = "Interdiction de tuez des licornes"
}
interact.s4_multi3 = {
	en = "No swearing and racism",
	fr = "Pas d'insulte ni de racisme"
}

--Which answer is needed for the quiz questions. interact.quiz1-4 takes true or false.
--True is left, false is right.
--Please, please spell true and false right!!! If you spell it wrong it won't work!
--interact.quiz can be 1, 2 or 3.
--1 is the top one by the question, 2 is the bottom left one, 3 is the bottom right one.
--Make sure these agree with your answers!
interact.quiz1 = false
interact.quiz2 = false
interact.quiz3 = true
interact.quiz4 = true
interact.quiz_multi = 3
