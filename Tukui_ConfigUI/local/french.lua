if GetLocale() == "frFR" then

	-- update needed msg
	TukuiL.option_update = "Vous devez mettre à jour votre interface Tukui pour bénéficier des derniers changements, visitez le site www.tukui.org"

	-- general
	TukuiL.option_general = "Général"
	TukuiL.option_general_uiscale = "Echelle auto de l'interface"
	TukuiL.option_general_override = "Utiliser l'interface Haute Résolution sur une Basse Résolution"
	TukuiL.option_general_multisample = "Protection Multisample (bordure de 1px clean)"
	TukuiL.option_general_customuiscale = "Echelle de l'interface (si échelle auto désactivée)"
 
	-- nameplate
	TukuiL.option_nameplates = "Barres d'info"
	TukuiL.option_nameplates_enable = "Activer les barres d'info"
	TukuiL.option_nameplates_enhancethreat = "Activer la gestion d'aggro, change automatiquement selon votre rôle:"
	TukuiL.option_nameplates_showhealth = "Montrer la vie sur les barres d'info des ennemis"
 	TukuiL.option_nameplates_combat = "Afficher les barres d'infos des ennemis seulement en combat"
 	TukuiL.option_nameplates_goodcolor = "Bonne couleur de menace, dépend de votre rôle (tank ou dps / heal)"
	TukuiL.option_nameplates_badcolor = "Mauvaise couleur de menace, dépend de votre rôle (tank ou dps / heal)"
	TukuiL.option_nameplates_transitioncolor = "Perte / Gain de couleur de menace"
 
	-- merchant
	TukuiL.option_merchant = "Commerce"
	TukuiL.option_merchant_autosell = "Vente auto des objets gris"
	TukuiL.option_merchant_autorepair = "Réparation auto de l'équipement"
	TukuiL.option_merchant_sellmisc = "Vente de certains objets définis (non-gris, inutile) automatiquement."
	TukuiL.option_merchant_guildrepair = "Réparation automatique depuis la banque de guilde (Si disponible)"
 
	-- bags
	TukuiL.option_bags = "Sacs"
	TukuiL.option_bags_enable = "Activer les sacs Tukui"
 
	-- datatext
	TukuiL.option_datatext = "Infos"
	TukuiL.option_datatext_24h = "Activer mode 24h"
	TukuiL.option_datatext_localtime = "Utiliser l'heure locale au lieu de l'heure serveur"
	TukuiL.option_datatext_bg = "Activer les stats en Champ de Bataille"
	TukuiL.option_datatext_hps = "Position Soin par seconde (0 pour désactiver)"
	TukuiL.option_datatext_guild = "Position Guild (0 pour désactiver)e"
	TukuiL.option_datatext_arp = "Position Pénétration d'Armure (0 pour désactiver)"
	TukuiL.option_datatext_mem = "Position Mémoire (0 pour désactiver)"
	TukuiL.option_datatext_bags = "Position Sacs (0 pour désactiver)"
	TukuiL.option_datatext_fontsize = "Taille du texte (0 pour désactiver)"
	TukuiL.option_datatext_fps_ms = "Position Latence et FPS (0 pour désactiver)"
	TukuiL.option_datatext_armor = "Position Armure (0 pour désactiver)"
	TukuiL.option_datatext_avd = "Position Esquive (0 pour désactiver)"
	TukuiL.option_datatext_power = "Position Puissance Attaque / Sorts (0 pour désactiver)"
	TukuiL.option_datatext_haste = "Position Hâte (0 pour désactiver)"
	TukuiL.option_datatext_friend = "Position Amis (0 pour désactiver)"
	TukuiL.option_datatext_time = "Position Heure (0 pour désactiver)"
	TukuiL.option_datatext_gold = "Position Pièces d'Or (0 pour désactiver)"
	TukuiL.option_datatext_dps = "Position Dégâts par seconde (0 pour désactiver)"
	TukuiL.option_datatext_crit = "Position Critique (0 pour désactiver)"
	TukuiL.option_datatext_dur = "Position Durabilité (0 pour désactiver)"
	TukuiL.option_datatext_currency = "Position Monnaie (0 pour désactiver)"
	TukuiL.option_datatext_micromenu = "Position Micro Menu (0 pour désactiver)"
	TukuiL.option_datatext_hit = "Position Toucher (0 pour désactiver)"
	TukuiL.option_datatext_mastery = "Position Maîtrise (0 pour désactiver)"
	TukuiL.option_datatext_classcolor = "Activer les couleurs de classe sur les Datatexts."
	TukuiL.option_datatext_color = "Choisir la couleur des Datatexts"
	TukuiL.option_datatext_style = "Choisir le style des datatexts"
	TukuiL.option_datatext_expreptext = "Activer le texte sur les barres de réputation et d’expérience."
	TukuiL.option_datatext_location_coords = "Activer les coordonnées sur le panneau d'emplacement."
	TukuiL.option_datatext_location = "Activer le panneau d'emplacement"
	TukuiL.option_datatext_exprepbars = "Activer les barres d'expérience et de réputation."
	TukuiL.option_datatext_regen = "Position de la regen mana (0 désactiver)"
	TukuiL.option_datatext_maptime = "Activer l'horloge sous la minimap"
	TukuiL.option_datatext_statblock = "Activer le bloc de statistiques dans le coin en haut à gauche."
 
	-- unit frames
	TukuiL.option_unitframes_unitframes = "Unit Frames"
	TukuiL.option_unitframes_combatfeedback = "Feedback des dégâts/soins sur joueur et cible"
	TukuiL.option_unitframes_runebar = "Afficher la barre de rune pour DK"
	TukuiL.option_unitframes_auratimer = "Afficher le timer sur les buffs"
	TukuiL.option_unitframes_totembar = "Afficher la barre de totem pour Chaman"
	TukuiL.option_unitframes_totalhpmp = "Afficher le total vie/pouvoir (mana/énergie/rage)"
	TukuiL.option_unitframes_playerparty = "Se voir dans le groupe"
	TukuiL.option_unitframes_aurawatch = "Afficher les buffs PVE en raid (Grid seulement)"
	TukuiL.option_unitframes_castbar = "Afficher la barre de cast"
	TukuiL.option_unitframes_targetaura = "Afficher les buffs des cibles"
	TukuiL.option_unitframes_saveperchar = "Sauvegarder la position des cadres par personnage"
	TukuiL.option_unitframes_playeraggro = "Afficher l'aggro sur soi"
	TukuiL.option_unitframes_smooth = "Activer les animations sur les barres de vie/mana/etc"
	TukuiL.option_unitframes_portrait = "Activer les portraits sur joueur et cible"
	TukuiL.option_unitframes_enable = "Activer Tukui Unit Frames"
	TukuiL.option_unitframes_enemypower = "Afficher le pouvoir (mana/énergie/rage) seulement sur l'ennemi"
	TukuiL.option_unitframes_gridonly = "Afficher que le mode Grid sur l'interface Healer"
	TukuiL.option_unitframes_healcomm = "Activer healcomm"
	TukuiL.option_unitframes_focusdebuff = "Afficher les debuffs du Focus"
	TukuiL.option_unitframes_raidaggro = "Afficher l'aggro dans le groupe/raid"
	TukuiL.option_unitframes_boss = "Activer les Boss Unit Frames"
	TukuiL.option_unitframes_enemyhostilitycolor = "Colorer la barre de vie des ennemis en fonction de l'hostilité"
	TukuiL.option_unitframes_healthvertical = "Voir la barre de vie verticalement dans l'interface Heal"
	TukuiL.option_unitframes_symbol = "Voir les symboles dans le groupe/raid"
	TukuiL.option_unitframes_threatbar = "Afficher la barre de menace"
	TukuiL.option_unitframes_enablerange = "Afficher la transparence pour la portée des membres du groupe/raid"
	TukuiL.option_unitframes_focus = "Afficher la cible du Focus"
	TukuiL.option_unitframes_latency = "Voir la latence sur la barre de cast"
	TukuiL.option_unitframes_icon = "Voir l'icone de sort sur la barre de cast"
	TukuiL.option_unitframes_playeraura = "Activer un mode de buff alternatif pour le joueur"
	TukuiL.option_unitframes_aurascale = "Taille du texte des buffs"
	TukuiL.option_unitframes_gridscale = "Taille de Grid"
	TukuiL.option_unitframes_manahigh = "Seuil Haut de la mana (Chasseurs)"
	TukuiL.option_unitframes_manalow = "Seuil Bas de la mana (Toutes classes à mana)"
	TukuiL.option_unitframes_range = "Transparence sur unité de Groupe/Raid hors de portée"
	TukuiL.option_unitframes_maintank = "Afficher Main Tank"
	TukuiL.option_unitframes_mainassist = "Afficher Main Heal"
	TukuiL.option_unitframes_unicolor = "Afficher le thème avec une seule couleur (barre de vie grise)"
	TukuiL.option_unitframes_totdebuffs = "Afficher les debuffs de la cible de la cible (interface Haute Resolution)"
	TukuiL.option_unitframes_classbar = "Afficher la barre de classe"
	TukuiL.option_unitframes_weakenedsoulbar = "Afficher la barre de debuff âme affaiblie (pour prêtres)"
	TukuiL.option_unitframes_onlyselfdebuffs = "Afficher seulement vos débuffs sur la cible"
	TukuiL.option_unitframes_focus = "Afficher la cible du Focus"
	TukuiL.option_unitframes_healthdeficit = "Activer le déficit de vie."
	TukuiL.option_unitframes_hidepower = "Cacher la barre d'énergie."
	TukuiL.option_unitframes_onlyselfbuffs = "Afficher uniquement vos buffs"
	TukuiL.option_unitframes_buffrows = "Nombre de lignes de buff"
	TukuiL.option_unitframes_debuffrows = "Nombre de lignes de debuff"
	TukuiL.option_unitframes_dcbclasscolor = "Activer les couleurs de classe sur la barre d'incantation"
	TukuiL.option_unitframes_sortname = "Trier les sorts par nom"
	TukuiL.option_unitframes_focusdebuffs = "Voir les debuffs sur votre focalisation"
	TukuiL.option_unitframes_focusbuffs = "Voir les buffs sur votre focalisation"
	TukuiL.option_unitframes_healthColor = "Choisir la couleur de la barre de vie"
	TukuiL.option_unitframes_cbcustomcolor = "Choisir la couleur de la barre d'incantation"
	TukuiL.option_unitframes_debuffHighlightFilter = "Activer la surbrillance des debuff sur l'unitframe"
	TukuiL.option_unitframes_healthBgColor = "Choisir la couleur de fond de l'unitframe"
	TukuiL.option_unitframes_deathknight = "Activer la barre de runes pour les Chevaliers de la mort"
	TukuiL.option_unitframes_warlock = "Activer la barre de fragments d'âme pour Démonistes"
	TukuiL.option_unitframes_shaman = "Activer la barre de totems pour les Chamans"
	TukuiL.option_unitframes_druid = "Activer la barre d'energie druidique pour les Druides équilibre."
	TukuiL.option_unitframes_paladin = "Activer la barre de puissance sacrée pour les Paladins."
	TukuiL.option_unitframes_playerHighlight = "Activer la surbrillance des debuff sur le joueur."
	TukuiL.option_unitframes_style = "Style de l'uniframe (Eclipse ou Cohesion)"
	TukuiL.option_unitframes_gradienthealth = "Adapte la couleur des barres de vie du raid par rapport à leur pourcentage de points de vie. (heal layout uniquement)"
	TukuiL.option_unitframes_mouseoverhighlight = "Activer la surbrillance au passage de la souris (heal layout uniquement)"
 
	-- loot
	TukuiL.option_loot = "Butin"
	TukuiL.option_loot_enableloot = "Activer fenêtre de butin"
	TukuiL.option_loot_autogreed = "Auto-cupidité pour les objets verts au level max"
	TukuiL.option_loot_enableroll = "Activer la fenêtre de choix du butin (cupitidé/besoin/passer)"
 
	-- map
	TukuiL.option_map = "Carte"
	TukuiL.option_map_enable = "Activer la carte Tukui"
 
	-- invite
	TukuiL.option_invite = "Invite"
	TukuiL.option_invite_autoinvite = "Activer l'Auto-Invite (Amis et Guilde)"
 
	-- tooltip
	TukuiL.option_tooltip = "Tooltip"
	TukuiL.option_tooltip_enable = "Activer les Tooltip"
	TukuiL.option_tooltip_hidecombat = "Cacher les tooltip en combat"
	TukuiL.option_tooltip_hidebutton = "Cacher les tooltip sur les barres d'actions"
	TukuiL.option_tooltip_hideuf = "Cacher les tooltip sur les Unit Frames"
	TukuiL.option_tooltip_cursor = "Afficher les tooltip sous le curseur"
 
	-- others
	TukuiL.option_others = "Autres"
	TukuiL.option_others_bg = "Auto-Libération en Champ de Bataille"
 
	-- reminder
	TukuiL.option_reminder = "Alerte d'Aura"
	TukuiL.option_reminder_enable = "Activer l'alerte d'aura du joueur"
	TukuiL.option_reminder_sound = "Activer une alerte sonore pour l'alerte d'aura"
 
	-- error
	TukuiL.option_error = "Message d'Erreur"
	TukuiL.option_error_hide = "Cacher le spam d'erreur au milieu de l'écran"
 
	-- action bar
	TukuiL.option_actionbar = "Barres d'Actions"
	TukuiL.option_actionbar_hidess = "Cacher barre de Changeforme/Totem"
	TukuiL.option_actionbar_showgrid = "Toujours montrer les grilles sur les barres d'actions"
	TukuiL.option_actionbar_enable = "Activer les barres d'actions Tukui"
	TukuiL.option_actionbar_rb = "Barres d'actions de droite au passage de la souris"
	TukuiL.option_actionbar_hk = "Voir les raccourcis sur les boutons"
	TukuiL.option_actionbar_ssmo = "Barre de Changeforme/Totem au passage de la souris"
	TukuiL.option_actionbar_rbn = "Nombre de barres d'actions en bas (1 ou 2)"
	TukuiL.option_actionbar_rn = "Nombre de barres d'actions à droite (1, 2 ou 3)"
	TukuiL.option_actionbar_buttonsize = "Taille des boutons de la barre d'action"
	TukuiL.option_actionbar_buttonspacing = "Espace entre les boutons de la barre d'action"
	TukuiL.option_actionbar_petbuttonsize = "Taille des boutons du familier/ChangeForme"
	TukuiL.option_actionbar_vertical_rightbars = "Activer la barre de droite verticale"
	TukuiL.option_actionbar_stancebuttonsize = "Choisir la taille des boutons de la barre de changement de positions"
	TukuiL.option_actionbar_vertical_shapeshift = "Activer la barre de changement de positions verticale"
	
	-- quest watch frame
	TukuiL.option_quest = "Quêtes"
	TukuiL.option_quest_movable = "Bouger la fenêtre d'Objectifs"
 
	-- arena
	TukuiL.option_arena = "Arène"
	TukuiL.option_arena_st = "Activer le traqueur de sorts ennemi"
	TukuiL.option_arena_uf = "Activer l'Unit Frame d'arène"
	
	-- pvp
	TukuiL.option_pvp = "Pvp"
	TukuiL.option_pvp_ii = "Activer les Icones d'Interruption"
 
	-- cooldowns
	TukuiL.option_cooldown = "Cooldowns"
	TukuiL.option_cooldown_enable = "Activer le cooldown numérique sur les boutons"
	TukuiL.option_cooldown_th = "Colorer en rouge le cooldown à X seconde(s)"
 
	-- chat
	TukuiL.option_chat = "Social"
	TukuiL.option_chat_enable = "Activer le Chat Tukui"
	TukuiL.option_chat_whispersound = "Jouer un son lors de la réception d'un message"
	TukuiL.option_chat_background = "Activer l'arrière plan du Chat"
	TukuiL.option_chat_height = "Choisir la hauteur du chat"
	TukuiL.option_chat_justify_Right = "Aligner le texte du chat à droite"
	
	-- buff
	TukuiL.option_auras = "Auras"
	TukuiL.option_auras_player = "Activer les frames buff/debuff de Tukui"
 
	TukuiL.option_button_reset = "Défaut"
	TukuiL.option_button_load = "Appliquer"
	TukuiL.option_button_close = "Fermer"
	TukuiL.option_setsavedsetttings = "Activer les paramètres par personnage"
	TukuiL.option_resetchar = "Êtes-vous sûr de vouloir réinitialiser les paramètres de votre personnage ?"
	TukuiL.option_resetall = "Êtes vous sûr de vouloir tout réinitialiser ?"
	TukuiL.option_perchar = "Êtes vous sûr de vouloir annuler/passer à des paramètres par personnage ?"
	TukuiL.option_makeselection = "Vous devez faire un choix pour continuer."
	
	-- combo
	TukuiL.option_combo = "Combo"
	TukuiL.option_combo_warrior = "Activer les combos Guerrier"
	TukuiL.option_combo_paladin = "Activer les combos Paladin"
	TukuiL.option_combo_shaman = "Activer les combos Chaman"
	TukuiL.option_combo_dknight = "Activer les combos Chevalier de la mort"
	TukuiL.option_combo_mage = "Activer les combos Mage"
	TukuiL.option_combo_druid = "Activer les combos Druide"
	TukuiL.option_combo_display = "Activer le module de combos"
	TukuiL.option_combo_hunter = "Activer les combos Chasseur"
	TukuiL.option_combo_warlock = "Activer les combos Démoniste"
	TukuiL.option_combo_priest = "Activer les combos Prêtres"
	
	-- other
	TukuiL.option_others_autoquest = "Activer la fonctionnalité des quêtes automatiques"
end