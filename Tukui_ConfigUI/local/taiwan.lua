if GetLocale() == "zhTW" then

	-- update needed msg
	TukuiL.option_update = "由於Tukui的重大更新, 您必須更新您的Tukui ConfigUI, 請移玉手至www.tukui.org"
	
	-- general
	TukuiL.option_general = "一般"
	TukuiL.option_general_uiscale = "自動調整使用者介面比例"
	TukuiL.option_general_override = "使用高解析度設定於低解析度"
	TukuiL.option_general_multisample = "多重採樣保護"
	TukuiL.option_general_customuiscale = "使用者介面比例(需要關閉自動調整)"
	TukuiL.option_general_backdropcolor = "設定面板背景顏色"
	TukuiL.option_general_bordercolor = "設定面板邊框顏色"	
 
	-- nameplate
	TukuiL.option_nameplates = "名條"
	TukuiL.option_nameplates_enable = "啟用名條模組"
	TukuiL.option_nameplates_enhancethreat = "啟用仇恨上色模式, 依照你的角色定位決定"
	TukuiL.option_nameplates_showhealth = "在名條上顯示生命"
	TukuiL.option_nameplates_combat = "只在戰鬥中顯示敵人名條"
	TukuiL.option_nameplates_goodcolor = "安全仇恨值顏色, 將根據你的角色定位決定"
	TukuiL.option_nameplates_badcolor = "危險威仇恨值顏色, 將根據你的角色定位決定"
	TukuiL.option_nameplates_transitioncolor = "流失或獲得仇恨值顏色"
 
	-- merchant
	TukuiL.option_merchant = "商人"
	TukuiL.option_merchant_autosell = "自動販賣灰色等級物品"
	TukuiL.option_merchant_autorepair = "自動修復裝備"
	TukuiL.option_merchant_sellmisc = "自動販賣特定物品(非灰色等級指定物品)"
	TukuiL.option_merchant_guildrepair = "自動使用公會修裝 (如果有開啟)"
 
	-- bags
	TukuiL.option_bags = "背包"
	TukuiL.option_bags_enable = "啟用整合背包"
 
	-- datatext
	TukuiL.option_datatext = "資訊欄位"
	TukuiL.option_datatext_24h = "啟用24小時制"
	TukuiL.option_datatext_localtime = "使用當地時間"
	TukuiL.option_datatext_bg = "啟用戰場資訊 (輸入0 以停用)"
	TukuiL.option_datatext_hps = "每秒治療 (輸入0 以停用)"
	TukuiL.option_datatext_guild = "公會資訊 (輸入0 以停用)"
	TukuiL.option_datatext_arp = "護甲穿透 (輸入0 以停用)"
	TukuiL.option_datatext_mem = "記憶體用量 (輸入0 以停用)"
	TukuiL.option_datatext_bags = "背包格數 (輸入0 以停用)"
	TukuiL.option_datatext_fontsize = "文字大小 (輸入0 以停用)"
	TukuiL.option_datatext_fps_ms = "延遲及畫面幀數 (輸入0 以停用)"
	TukuiL.option_datatext_armor = "護甲值 (輸入0 以停用)"
	TukuiL.option_datatext_avd = "閃躲 (輸入0 以停用)"
	TukuiL.option_datatext_power = "攻強/法傷 (輸入0 以停用)"
	TukuiL.option_datatext_haste = "加速 (輸入0 以停用)"
	TukuiL.option_datatext_friend = "好友資訊 (輸入0 以停用)"
	TukuiL.option_datatext_time = "時間 (輸入0 以停用)"
	TukuiL.option_datatext_gold = "金錢 (輸入0 以停用)"
	TukuiL.option_datatext_dps = "每秒傷害 (輸入0 以停用)"
	TukuiL.option_datatext_crit = "致命 (輸入0 以停用)"
	TukuiL.option_datatext_dur = "耐久值 (輸入0 以停用)"
	TukuiL.option_datatext_currency = "兌換通貨 (輸入0 以停用)"
	TukuiL.option_datatext_micromenu = "小型菜單 (輸入0 以停用)"
	TukuiL.option_datatext_hit = "命中 (輸入0 以停用)"
	TukuiL.option_datatext_mastery = "精通 (輸入0 以停用)"
	TukuiL.option_datatext_classcolor = "啟用職業顏色的資訊文字"
	TukuiL.option_datatext_color = "選擇資訊文字的顏色"
	TukuiL.option_datatext_style = "選擇資訊文字的樣式"
	TukuiL.option_datatext_expreptext = "啟用經驗值與聲望值條上的文字"
	TukuiL.option_datatext_location_coords = "所在地面板上顯示座標"
	TukuiL.option_datatext_location = "啟用所在地面板"
	TukuiL.option_datatext_exprepbars = "啟用經驗值及聲望值條"
	TukuiL.option_datatext_regen = "法力恢復 (輸入0以停用)"
	TukuiL.option_datatext_maptime = "啟用小地圖下的時鐘"
	TukuiL.option_datatext_statblock = "啟用左上角的資訊欄位"
 
	-- unit frames
	TukuiL.option_unitframes_unitframes = "單位視窗"
	TukuiL.option_unitframes_combatfeedback = "顯示戰鬥資訊於玩家及目標視窗"
	TukuiL.option_unitframes_runebar = "啟用死亡騎士符文列"
	TukuiL.option_unitframes_auratimer = "啟用光環上計時"
	TukuiL.option_unitframes_totembar = "啟用薩滿圖騰列"
	TukuiL.option_unitframes_totalhpmp = "顯示總生命/能量值"
	TukuiL.option_unitframes_playerparty = "隊伍中顯示玩家"
	TukuiL.option_unitframes_aurawatch = "啟用PVE團隊光環監控 (Grid專用)"
	TukuiL.option_unitframes_castbar = "啟用施法條"
	TukuiL.option_unitframes_targetaura = "啟用目標光環"
	TukuiL.option_unitframes_saveperchar = "依角色記錄單位視窗位置"
	TukuiL.option_unitframes_playeraggro = "啟用玩家仇恨顯示"
	TukuiL.option_unitframes_smooth = "啟用smooth bar插件"
	TukuiL.option_unitframes_portrait = "啟用玩家及目標視窗人物畫像"
	TukuiL.option_unitframes_enable = "啟用Tukui單位視窗"
	TukuiL.option_unitframes_enemypower = "只顯示敵對目標能量值"
	TukuiL.option_unitframes_gridonly = "啟用Grid限定治療介面"
	TukuiL.option_unitframes_healcomm = "啟用healcomm插件"
	TukuiL.option_unitframes_focusdebuff = "啟用專注目標負面狀態"
	TukuiL.option_unitframes_raidaggro = "啟用隊伍/團隊仇恨顯示"
	TukuiL.option_unitframes_boss = "啟用首領單位視窗"
	TukuiL.option_unitframes_enemyhostilitycolor = "敵人生命條以敵對狀態上色"
	TukuiL.option_unitframes_healthvertical = "顯示Grid介面縱向生命條"
	TukuiL.option_unitframes_symbol = "顯示隊伍/團隊標記"
	TukuiL.option_unitframes_threatbar = "啟用仇恨條"
	TukuiL.option_unitframes_enablerange = "啟用隊伍/團隊距離淡出"
	TukuiL.option_unitframes_focus = "啟用專注目標的目標"
	TukuiL.option_unitframes_bordercolor = "設定單位框架的邊框顏色"
	TukuiL.option_unitframes_latency = "顯示施法延遲"
	TukuiL.option_unitframes_icon = "顯示施法條法術圖示"
	TukuiL.option_unitframes_playeraura = "啟用玩家其它光環模式"
	TukuiL.option_unitframes_aurascale = "光環文字大小調整"
	TukuiL.option_unitframes_gridscale = "Grid大小調整"
	TukuiL.option_unitframes_manahigh = "法力過高警告(獵人專用)"
	TukuiL.option_unitframes_manalow = "法力過低警告(法系職業專用)"
	TukuiL.option_unitframes_range = "隊伍/團隊單位超出距離透明值"
	TukuiL.option_unitframes_maintank = "啟用主坦克視窗"
	TukuiL.option_unitframes_mainassist = "啟用主助攻視窗"
	TukuiL.option_unitframes_unicolor = "啟用特殊顏色模式(灰色生命條)"
	TukuiL.option_unitframes_totdebuffs = "啟用目標的目標負面狀態(高解析度專用)"
	TukuiL.option_unitframes_classbar = "啟用職業專用列"
	TukuiL.option_unitframes_weakenedsoulbar = "啟用虛弱靈魂指示 (牧師)"
	TukuiL.option_unitframes_onlyselfdebuffs = "只在目標頭像上顯示自己釋放的減益效果"
	TukuiL.option_unitframes_focus = "開啟專注目標的目標"
	TukuiL.option_unitframes_healthdeficit = "啟用生命值差額"
	TukuiL.option_unitframes_hidepower = "隱藏能力條"
	TukuiL.option_unitframes_onlyselfbuffs = "只顯示你的所施放的增益狀態"
	TukuiL.option_unitframes_buffrows = "增益狀態的行數"
	TukuiL.option_unitframes_debuffrows = "減益狀態的行數"
	TukuiL.option_unitframes_dcbclasscolor = "啟用職業顏色的施法條"
	TukuiL.option_unitframes_sortname = "以名稱排序"
	TukuiL.option_unitframes_focusdebuffs = "顯示專注單位的減益狀態"
	TukuiL.option_unitframes_focusbuffs = "顯示專注單位的增益狀態"
	TukuiL.option_unitframes_healthColor = "選擇生命值顏色"
	TukuiL.option_unitframes_cbcustomcolor = "選擇施法條顏色"
	TukuiL.option_unitframes_debuffHighlightFilter = "單位框架上啟用減益狀態高亮"
	TukuiL.option_unitframes_healthBgColor = "選擇單位框架的背景顏色"
	TukuiL.option_unitframes_deathknight = "啟用死亡騎士符文列"
	TukuiL.option_unitframes_warlock = "啟用術士的靈魂碎片條"
	TukuiL.option_unitframes_shaman = "啟用薩滿圖騰列"
	TukuiL.option_unitframes_druid = "啟用德魯伊的日/月條"
	TukuiL.option_unitframes_paladin = "啟用聖騎士的神聖能量條"
	TukuiL.option_unitframes_playerHighlight = "啟用玩家身上的減益狀態高亮"
	TukuiL.option_unitframes_style = "單位框架樣式 (Eclipse 或 Cohesion)"
	TukuiL.option_unitframes_gradienthealth = "由生命值百分比決定團隊生命值顏色 (治療介面專用)"
	TukuiL.option_unitframes_mouseoverhighlight = "啟用游標懸停高亮 (治療介面專用)"
 
	-- loot
	TukuiL.option_loot = "戰利品"
	TukuiL.option_loot_enableloot = "啟用戰利品視窗"
	TukuiL.option_loot_autogreed = "啟用自動貪婪物品(只限用於等級80)"
	TukuiL.option_loot_enableroll = "啟用骰裝視窗"
 
	-- map
	TukuiL.option_map = "地圖"
	TukuiL.option_map_enable = "啟用地圖"
 
	-- invite
	TukuiL.option_invite = "邀請"
	TukuiL.option_invite_autoinvite = "啟用自動接受組隊邀請及自動邀請(限用好友及公會成員)"
 
	-- tooltip
	TukuiL.option_tooltip = "提示資訊"
	TukuiL.option_tooltip_enable = "啟用提示資訊"
	TukuiL.option_tooltip_hidecombat = "於戰鬥中隱藏指示資訊"
	TukuiL.option_tooltip_hidebutton = "隱藏動作列按鍵提示資訊"
	TukuiL.option_tooltip_hideuf = "隱藏單位視窗提示資訊"
	TukuiL.option_tooltip_cursor = "啟用滑鼠旁提示訊息"
 
	-- others
	TukuiL.option_others = "其它"
	TukuiL.option_others_bg = "啟用戰場自動釋放靈魂"
 
	-- reminder
	TukuiL.option_reminder = "光環警告"
	TukuiL.option_reminder_enable = "啟用玩家光環警告"
	TukuiL.option_reminder_sound = "啟用光環警告音效"
 
	-- error
	TukuiL.option_error = "錯誤訊息"
	TukuiL.option_error_hide = "隱藏螢幕中間錯誤訊息"
 
	-- action bar
	TukuiL.option_actionbar = "動作列"
	TukuiL.option_actionbar_hidess = "隱藏姿勢列及圖騰列"
	TukuiL.option_actionbar_showgrid = "永遠顯示動作格"
	TukuiL.option_actionbar_enable = "啟用Tukui動作列"
	TukuiL.option_actionbar_rb = "啟用滑鼠移至右側動作列時顯示"
	TukuiL.option_actionbar_hk = "顯示按鍵文字"
	TukuiL.option_actionbar_ssmo = "滑鼠移至姿勢列或圖騰列時顯示"
	TukuiL.option_actionbar_rbn = "底部動作列列數(1 或 2)"
	TukuiL.option_actionbar_rn = "右側動作列列數 (1, 2 或 3)"
	TukuiL.option_actionbar_buttonsize = "主要熱鍵大小"
	TukuiL.option_actionbar_buttonspacing = "主要熱鍵間隔距離"
	TukuiL.option_actionbar_petbuttonsize = "寵物或變形列按鍵大小"
	TukuiL.option_actionbar_vertical_rightbars = "啟用右邊垂直的動作列"
	TukuiL.option_actionbar_stancebuttonsize = "設定姿勢列大小"
	TukuiL.option_actionbar_vertical_shapeshift = "啟用垂直的姿勢列"
	
	-- quest watch frame
	TukuiL.option_quest = "任務欄"
	TukuiL.option_quest_movable = "可移動任務欄"
 
	-- arena
	TukuiL.option_arena = "競技場"
	TukuiL.option_arena_st = "啟用競技場敵方法術追蹤"
	TukuiL.option_arena_uf = "啟用競技場單位視窗"
	
	-- pvp
	TukuiL.option_pvp = "PvP"
	TukuiL.option_pvp_ii = "啟用打斷圖示"
 
	-- cooldowns
	TukuiL.option_cooldown = "冷卻"
	TukuiL.option_cooldown_enable = "啟用按鍵冷卻倒數"
	TukuiL.option_cooldown_th = "冷卻小於X秒倒數以紅字顯示"
 
	-- chat
	TukuiL.option_chat = "對話框"
	TukuiL.option_chat_enable = "啟用Tukui對話框"
	TukuiL.option_chat_whispersound = "收到悄悄話時以音效提醒"
	TukuiL.option_chat_background = "啟用對話框背景"
	TukuiL.option_chat_height = "設定聊天視窗高度"
	TukuiL.option_chat_justify_Right = "以右對齊的聊天文字"
		
	-- buff
	TukuiL.option_auras = "Auras"
	TukuiL.option_auras_player = "Enable Tukui Buff/Debuff Frames"
 
	-- buttons
	TukuiL.option_button_reset = "重置"
	TukuiL.option_button_load = "讀取"
	TukuiL.option_button_close = "關閉"
	TukuiL.option_setsavedsetttings = "依角色儲存設定"
	TukuiL.option_resetchar = "你確定要將你的角色設定回復到預設設定嗎?"
	TukuiL.option_resetall = "你確定要將你所有的設定回復到系統預設值嗎?"
	TukuiL.option_perchar = "你確定要啟用或者關閉依角色儲存設定的模式嗎?"
	TukuiL.option_makeselection = "你必需作出選擇才能繼續設定"
	
	-- combo
	TukuiL.option_combo = "連擊點"
	TukuiL.option_combo_warrior = "啟用戰士連擊點"
	TukuiL.option_combo_paladin = "啟用聖騎士連擊點"
	TukuiL.option_combo_shaman = "啟用薩滿連擊點"
	TukuiL.option_combo_dknight = "啟用死亡騎士連擊點"
	TukuiL.option_combo_mage = "啟用法師連擊點"
	TukuiL.option_combo_druid = "啟用德魯伊連擊點"
	TukuiL.option_combo_display = "啟用連擊點模組"
	TukuiL.option_combo_hunter = "啟用獵人連擊點"
	TukuiL.option_combo_warlock = "啟用術士連擊點"
	TukuiL.option_combo_priest = "啟用牧師連擊點"
	
	-- others
	TukuiL.option_others_autoquest = "啟用自動接取任務功能"
end