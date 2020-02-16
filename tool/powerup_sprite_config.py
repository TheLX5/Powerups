import tkinter as tk
import tkinter.tix as tix
from tkinter import ttk
from tkinter import filedialog
from tkinter import messagebox
from tkinter.messagebox import showerror
import webbrowser
import os
import json

class Toolbar(tk.Frame):
	def __init__(self, master):
		self.master = master
		
		self.powerup_specific_defs = []
		self.powerup_list_options = []
			
		self.frame = tk.Frame(self.master)
		self.menubar = tk.Menu(self.frame)
		
		self.filemenu = tk.Menu(self.menubar, tearoff=0)
		self.filemenu.add_command(label="Open", command=self.file_open)
		self.filemenu.add_command(label="Save changes to files", command=self.file_save)
		self.filemenu.entryconfig(1, state="disabled")
		self.filemenu.add_separator()
		self.filemenu.add_command(label="Close", command=root.destroy)
		self.menubar.add_cascade(label="File", menu=self.filemenu)
		
		self.aboutmenu = tk.Menu(self.menubar, tearoff=0)
		self.aboutmenu.add_command(label="Custom Powerups Wiki", command=self.about_wiki)
		self.menubar.add_cascade(label="About", menu=self.aboutmenu)
		
		self.master.config(menu=self.menubar)
                
	def file_open(self):
		global current_sprite
		self.powerups_defs_path = tk.filedialog.askopenfilename(
								  initialdir="./",
								  title="Open powerup_defs.asm",
								  filetypes=(("Custom Powerups configuration file","powerup_defs.asm"),("All files","*.*")))
		if self.powerups_defs_path:
			try:
				with open(self.powerups_defs_path, "r") as f:
					file = f.read()
					if ";I hope you did read the readme." not in file:
						tk.messagebox.showerror("Open powerup_defs.asm", "This isn't a valid powerup_defs.asm file!")
						return
				self.powerup_files_path = self.powerups_defs_path[:self.powerups_defs_path.rfind("/")+1]
				if not(os.path.isdir(self.powerup_files_path+"powerups_files/powerup_interaction_code")):
					tk.messagebox.showerror("Open powerup_defs.asm", "This isn't the powerup_defs.asm file you should open.\n\nSelect the one that is in the same folder as powerup.asm.")
					return
			except Exception as e:
				tk.messagebox.showerror("Open powerup_defs.asm", "Failed to read powerup_defs.asm file.")
				return
		else:
			tk.messagebox.showerror("Open powerup_defs.asm", "No file was providen.")
			return
				
		self.pixi_list_path = tk.filedialog.askopenfilename(
							  initialdir="./",
							  title="Open PIXI sprite list.txt",
							  filetypes=(("PIXI sprite list","*.txt"),("All files","*.*")))
		if self.pixi_list_path:
			try:
				with open(self.pixi_list_path, "r") as f:
					file = f.read()
					if "EXTENDED" not in file:
						tk.messagebox.showerror("Open PIXI sprite list", "This isn't a valid PIXI sprite list file.")
						return
					self.pixi_path = self.pixi_list_path[:self.pixi_list_path.rfind("/")+1]
					if not(os.path.isdir(self.pixi_path+"/extended/powerup/")):
						tk.messagebox.showerror("Open PIXI sprite list", "Can't find the settings files of the projectiles.\n\nBe sure that PIXI's sprite list exists in the same folder as the extended sprites folder.")
						return
			except Exception as e:
				tk.messagebox.showerror("Open PIXI sprite list", "Failed to read PIXI sprite list.")
				return
		else:
			tk.messagebox.showerror("Open PIXI sprite list", "No file was providen.")
			return
			
		self.filemenu.entryconfig(1, state="normal")
		
		self.load_files = [self.pixi_path+"extended/powerup/mario_hammer_props.asm",
						   self.pixi_path+"/extended/powerup/mario_boomerang_props.asm",
						   self.pixi_path+"/extended/powerup/mario_iceball_props.asm",
						   self.pixi_path+"/extended/powerup/mario_superball_props.asm",
						   self.pixi_path+"/extended/powerup/mario_bubble_props.asm",
						   self.pixi_path+"/extended/powerup/mario_elecball_props.asm",
						   self.powerup_files_path+"powerups_files/powerup_interaction_code/tanooki_table.asm",
						   self.powerup_files_path+"powerups_files/powerup_interaction_code/mini_table.asm",
						   self.powerup_files_path+"powerups_files/powerup_interaction_code/shell_suit_table.asm",
						   self.powerup_files_path+"powerups_files/powerup_interaction_code/cat_table.asm"]
					  
		self.compare = ["hammer_normal_sprites:",
						"boomerang_normal_sprites:",
						"iceball_normal_sprites:",
						"superball_normal_sprites:",
						"bubble_normal_sprites:",
						"elecball_normal_sprites:",
						"..normal_sprites_table",
						"..normal_sprites_table",
						"..normal_sprites_table",
						"..normal_sprites_table"]
		
		self.names = ["hammer",
					  "boomerang",
					  "iceball",
					  "superball",
					  "bubble",
					  "elecball",
					  "statue",
					  "mini",
					  "shell",
					  "cat"]
		
		for x in range(len(self.load_files)):
			with open(self.load_files[x], "r") as f:
				settings_file = f.readlines()
				i = 256
				for line in settings_file:
					line.rstrip('\r\n')
					try:
						if self.compare[x] in line:
							i = 0
							continue
						elif line[:3] == "db ":
							line = line[3:]
							if line[0] == "$":
								value = hex("0x"+line[1:3])
							elif line[0] == "%":
								value = int(line[1:9],2)
							else:
								continue
							if x == 0:
								sprite_names[i] = line[line.find(";"):][2:]
							settings[self.names[x]][i] = value
							i = i+1
					except:
						continue
		
		with open(self.pixi_path+"/list.txt", "r") as f:
			pixi_list = f.readlines()
			for line in pixi_list:
				if ("EXTENDED" or "CLUSTER") in line:
					break
				if len(line) > 2:
					try:
						num = int("0x"+line[:2], 16)
					except:
						pass
					filename = line[3:].split()[0]
					if filename[-5:] == ".json":
						with open(self.pixi_path+"sprites/"+filename, "r") as j:
							current_json = json.load(j)
							sprite_names[num+256] = sprite_names[num+256].split(":")[0] + ": " + str(current_json["Displays"][0]["Description"].split("\\n")[0])
					else:
						sprite_names[num+256] = sprite_names[num+256].split(":")[0] + ": " + line[3:]
				i = 0
		
		for child in self.master.winfo_children():
			if i == 0:
				i = i+1
				continue
			if not (isinstance(child, tk.Frame) or isinstance(child, tk.LabelFrame)):
				child.configure(state="normal")
				continue
			for child2 in child.winfo_children():
				if not (isinstance(child2, tk.Frame) or isinstance(child2, tk.LabelFrame)):
					child2.configure(state="normal")
					continue
				for child3 in child2.winfo_children():
					if not (isinstance(child3, tk.Frame) or isinstance(child3, tk.LabelFrame)):
						child3.configure(state="normal")
						if isinstance(child3, ttk.Combobox):
							child3.configure(state="readonly")
						continue
					for child4 in child3.winfo_children():
						if not (isinstance(child4, tk.Frame) or isinstance(child4, tk.LabelFrame)):
							child4.configure(state="normal")
							if isinstance(child4, ttk.Combobox):
								child4.configure(state="readonly")
							continue
						for child5 in child4.winfo_children():
							if not (isinstance(child5, tk.Frame) or isinstance(child5, tk.LabelFrame)):
								child5.configure(state="normal")
								if isinstance(child5, ttk.Combobox):
									child5.configure(state="readonly")
								continue
							for child6 in child5.winfo_children():
								if not (isinstance(child6, tk.Frame) or isinstance(child6, tk.LabelFrame)):
									child6.configure(state="normal")
									if isinstance(child6, ttk.Combobox):
										child6.configure(state="readonly")
										
		current_sprite = 0
		mainframe.sprite_list["values"] = sprite_names
		mainframe.sprite_list.current(0)
		mainframe.update_sprite_data()

	def file_save(self):
		for x in range(len(self.load_files)):
			with open(self.load_files[x], "r") as f:
				original_asm = f.readlines()
			i = 256
			with open(self.load_files[x], "w") as new_asm:
				for line in original_asm:
					if self.compare[x] in line:
						i = 0
					if line[:2] == "db":
						data = format(settings[self.names[x]][i],'#010b')
						line = "db %"+str(data)[2:]+"			; "+sprite_names[i]
						new_asm.write(line.replace('\r', '').replace('\n', '')+"\n")
						i = i+1
					else:
						new_asm.write(line)
					
		tk.messagebox.showinfo("Save changes to files", "Files sucessfully updated.\n\nPlease proceed to reinsert the main patch and PIXI sprites.")

	def about_wiki(self):
		self.website = "https://github.com/TheLX5/Powerups/wiki/1.-Main-Page"
		webbrowser.open(self.website,1)


class MainFrame(tk.Frame):
	def __init__(self, master):
		self.master = master
		
		self.main_frame_top = tk.Frame(master)
		self.main_frame_middle = tk.Frame(master)
		self.main_frame_bottom = tk.Frame(master)
		
		self.sprite_selector()
		
		self.middle_container_1 = tk.Frame(self.main_frame_middle)
		self.middle_container_2 = tk.Frame(self.main_frame_middle)
		self.middle_container_1.grid(row=0, column=0, sticky="nsew")
		self.middle_container_2.grid(row=0, column=1, sticky="nsew")
		self.main_frame_middle.grid_columnconfigure(0, weight=1, uniform="group1")
		self.main_frame_middle.grid_columnconfigure(1, weight=1, uniform="group1")
		self.main_frame_middle.grid_rowconfigure(0, weight=1)
		
		self.hammer_configuration(self.middle_container_1)
		self.superball_configuration(self.middle_container_1)
		self.iceball_configuration(self.middle_container_1)
		self.boomerang_configuration(self.middle_container_2)
		self.bubble_configuration(self.middle_container_2)
		self.elecball_configuration(self.middle_container_2)
		
		self.statue_configuration(self.middle_container_1)
		self.cat_configuration(self.middle_container_1)
		self.mini_configuration(self.middle_container_2)
		self.shell_configuration(self.middle_container_2)
		
		self.main_frame_top.pack(side="top", fill="x", padx=2, pady=2)
		self.main_frame_middle.pack(fill="both", padx=2, pady=2)
		self.main_frame_bottom.pack(fill="x", padx=2, pady=2)
		
		i = 0
		for child in self.master.winfo_children():
			if i == 0:
				i = i+1
				continue
			if not (isinstance(child, tk.Frame) or isinstance(child, tk.LabelFrame)):
				child.configure(state="disabled")
				continue
			for child2 in child.winfo_children():
				if not (isinstance(child2, tk.Frame) or isinstance(child2, tk.LabelFrame)):
					child2.configure(state="disabled")
					continue
				for child3 in child2.winfo_children():
					if not (isinstance(child3, tk.Frame) or isinstance(child3, tk.LabelFrame)):
						child3.configure(state="disabled")
						continue
					for child4 in child3.winfo_children():
						if not (isinstance(child4, tk.Frame) or isinstance(child4, tk.LabelFrame)):
							child4.configure(state="disabled")
							continue
						for child5 in child4.winfo_children():
							if not (isinstance(child5, tk.Frame) or isinstance(child5, tk.LabelFrame)):
								child5.configure(state="disabled")
								continue
							for child6 in child5.winfo_children():
								if not (isinstance(child6, tk.Frame) or isinstance(child6, tk.LabelFrame)):
									child6.configure(state="disabled")

########################################################

	def sprite_selector(self):
		self.sprite_selector_widget = tk.LabelFrame(self.main_frame_top, text="General", padx=5, pady=5)
		self.sprite_selector_widget.pack(fill="x", padx=3, pady=1)
		
		self.sprite_list_container = tk.Frame(self.sprite_selector_widget)
		self.sprite_list_container.pack(side=tk.LEFT)
		
		self.sprite_list_label = tk.Label(self.sprite_list_container , text="Sprite: ")
		self.sprite_list_label.pack(side=tk.LEFT)
		
		self.sprite_list = ttk.Combobox(self.sprite_list_container,
										state="readonly",
										height=20,
										width=50,
										values=sprite_names)
		self.sprite_list.bind("<<ComboboxSelected>>", self.selected_sprite)
		self.sprite_list.current(0)
		self.sprite_list.pack(side=tk.LEFT)
		
		self.sprite_save_button = ttk.Button(self.sprite_selector_widget, text="Save this sprite", width=25, command=self.save_sprite_data)
		self.sprite_save_button.pack()
	
	def selected_sprite(self, event):
		global current_sprite
		current_sprite = self.sprite_list.current()
		self.update_sprite_data()
		
	def hammer_configuration(self, main_widget):
		self.hammer_config_widget = tk.LabelFrame(main_widget, text="Hammer", padx=5, pady=5)
		self.hammer_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.hammer_immunity_container = tk.Frame(self.hammer_config_widget)
		self.hammer_immunity_checkbox = tk.Checkbutton(self.hammer_immunity_container,
													   borderwidth=0,
													   variable=projectile_props["hammer_immunity"][0])
		self.hammer_immunity_checkbox.pack(side=tk.LEFT)
		self.hammer_immunity_label = tk.Label(self.hammer_immunity_container,text=projectile_props["hammer_immunity"][2])
		self.hammer_immunity_label.pack(side=tk.LEFT)
		
		self.hammer_disable_container = tk.Frame(self.hammer_config_widget)
		self.hammer_disable_checkbox = tk.Checkbutton(self.hammer_disable_container,
													  borderwidth=0,
													  variable=projectile_props["hammer_disable"][0])
		self.hammer_disable_checkbox.pack(side=tk.LEFT)
		self.hammer_disable_label = tk.Label(self.hammer_disable_container,text=projectile_props["hammer_disable"][2])
		self.hammer_disable_label.pack(side=tk.LEFT)
		
		self.hammer_immunity_container.pack(fill="x")
		self.hammer_disable_container.pack(fill="x")
		
	def boomerang_configuration(self, main_widget):
		self.boomerang_config_widget = tk.LabelFrame(main_widget, text="Boomerang", padx=5, pady=5)
		self.boomerang_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.boomerang_immunity_container = tk.Frame(self.boomerang_config_widget)
		self.boomerang_immunity_checkbox = tk.Checkbutton(self.boomerang_immunity_container,
														  borderwidth=0,
														  variable=projectile_props["boomerang_immunity"][0])
		self.boomerang_immunity_checkbox.pack(side=tk.LEFT)
		self.boomerang_immunity_label = tk.Label(self.boomerang_immunity_container,text=projectile_props["boomerang_immunity"][2])
		self.boomerang_immunity_label.pack(side=tk.LEFT)
		
		self.boomerang_disable_container = tk.Frame(self.boomerang_config_widget)
		self.boomerang_disable_checkbox = tk.Checkbutton(self.boomerang_disable_container,
														 borderwidth=0,
														 variable=projectile_props["boomerang_disable"][0])
		self.boomerang_disable_checkbox.pack(side=tk.LEFT)
		self.boomerang_disable_label = tk.Label(self.boomerang_disable_container,text=projectile_props["boomerang_disable"][2])
		self.boomerang_disable_label.pack(side=tk.LEFT)

		self.boomerang_retrieve_container = tk.Frame(self.boomerang_config_widget)
		self.boomerang_retrieve_checkbox = tk.Checkbutton(self.boomerang_retrieve_container,
														  borderwidth=0,
														  onvalue=3,
														  offvalue=0,
														  variable=projectile_props["boomerang_retrieve"][0])
		self.boomerang_retrieve_checkbox.pack(side=tk.LEFT)
		self.boomerang_retrieve_label = tk.Label(self.boomerang_retrieve_container,text=projectile_props["boomerang_retrieve"][2])
		self.boomerang_retrieve_label.pack(side=tk.LEFT)
		
		self.boomerang_immunity_container.pack(fill="x")
		self.boomerang_disable_container.pack(fill="x")
		self.boomerang_retrieve_container.pack(fill="x")
		
	def iceball_configuration(self, main_widget):
		self.iceball_config_widget = tk.LabelFrame(main_widget, text="Iceball", padx=5, pady=5)
		self.iceball_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.iceball_immunity_container = tk.Frame(self.iceball_config_widget)
		self.iceball_immunity_checkbox = tk.Checkbutton(self.iceball_immunity_container,
														borderwidth=0,
														variable=projectile_props["iceball_immunity"][0])
		self.iceball_immunity_checkbox.pack(side=tk.LEFT)
		self.iceball_immunity_label = tk.Label(self.iceball_immunity_container,text=projectile_props["iceball_immunity"][2])
		self.iceball_immunity_label.pack(side=tk.LEFT)
		
		self.iceball_disable_container = tk.Frame(self.iceball_config_widget)
		self.iceball_disable_checkbox = tk.Checkbutton(self.iceball_disable_container,
													   borderwidth=0,
													   variable=projectile_props["iceball_disable"][0])
		self.iceball_disable_checkbox.pack(side=tk.LEFT)
		self.iceball_disable_label = tk.Label(self.iceball_disable_container,text=projectile_props["iceball_disable"][2])
		self.iceball_disable_label.pack(side=tk.LEFT)
		
		self.iceball_smoke_container = tk.Frame(self.iceball_config_widget)
		self.iceball_smoke_checkbox = tk.Checkbutton(self.iceball_smoke_container,
													 borderwidth=0,
													 variable=projectile_props["iceball_smoke"][0])
		self.iceball_smoke_checkbox.pack(side=tk.LEFT)
		self.iceball_smoke_label = tk.Label(self.iceball_smoke_container,text=projectile_props["iceball_smoke"][2])
		self.iceball_smoke_label.pack(side=tk.LEFT)
		
		self.iceball_coin_container = tk.Frame(self.iceball_config_widget)
		self.iceball_coin_checkbox = tk.Checkbutton(self.iceball_coin_container,
													 borderwidth=0,
													 variable=projectile_props["iceball_coin"][0])
		self.iceball_coin_checkbox.pack(side=tk.LEFT)
		self.iceball_coin_label = tk.Label(self.iceball_coin_container,text=projectile_props["iceball_coin"][2])
		self.iceball_coin_label.pack(side=tk.LEFT)
			
		self.iceball_x_disp_container = tk.Frame(self.iceball_config_widget)
		self.iceball_x_disp_checkbox = tk.Checkbutton(self.iceball_x_disp_container,
													  borderwidth=0,
													  variable=projectile_props["iceball_x_disp"][0])
		self.iceball_x_disp_checkbox.pack(side=tk.LEFT)
		self.iceball_x_disp_label = tk.Label(self.iceball_x_disp_container,text=projectile_props["iceball_x_disp"][2])
		self.iceball_x_disp_label.pack(side=tk.LEFT)
		
		self.iceball_y_disp_container = tk.Frame(self.iceball_config_widget)
		self.iceball_y_disp_checkbox = tk.Checkbutton(self.iceball_y_disp_container,
													  borderwidth=0,
													  variable=projectile_props["iceball_y_disp"][0])
		self.iceball_y_disp_checkbox.pack(side=tk.LEFT)
		self.iceball_y_disp_label = tk.Label(self.iceball_y_disp_container,text=projectile_props["iceball_y_disp"][2])
		self.iceball_y_disp_label.pack(side=tk.LEFT)
		
		self.iceball_block_size_container = tk.Frame(self.iceball_config_widget)
		self.iceball_block_size_label = tk.Label(self.iceball_block_size_container,text=projectile_props["iceball_block_size"][2])
		self.iceball_block_size_label.pack(side=tk.LEFT)
		self.iceball_block_size_combo_box = ttk.Combobox(self.iceball_block_size_container,
														 state="readonly",
														 height=20,
														 width=8,
														 values=["16x16",
																 "16x32",
																 "32x16",
																 "32x32"])
		self.iceball_block_size_combo_box.bind("<<ComboboxSelected>>", self.selected_ice_block_size)
		self.iceball_block_size_combo_box.current(projectile_props["iceball_block_size"][0].get())
		self.iceball_block_size_combo_box.pack(side=tk.LEFT)
		
		self.iceball_immunity_container.pack(fill="x")
		self.iceball_disable_container.pack(fill="x")
		self.iceball_smoke_container.pack(fill="x")
		self.iceball_coin_container.pack(fill="x")
		self.iceball_block_size_container.pack(fill="x")
		self.iceball_x_disp_container.pack(fill="x")
		self.iceball_y_disp_container.pack(fill="x")
		
	def selected_ice_block_size(self, event):
		projectile_props["iceball_block_size"][0].set(self.iceball_block_size_combo_box.current())
		
	def superball_configuration(self, main_widget):
		self.superball_config_widget = tk.LabelFrame(main_widget, text="Superball", padx=5, pady=5)
		self.superball_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.superball_immunity_container = tk.Frame(self.superball_config_widget)
		self.superball_immunity_checkbox = tk.Checkbutton(self.superball_immunity_container,
													  borderwidth=0,
													  variable=projectile_props["superball_immunity"][0])
		self.superball_immunity_checkbox.pack(side=tk.LEFT)
		self.superball_immunity_label = tk.Label(self.superball_immunity_container,text=projectile_props["superball_immunity"][2])
		self.superball_immunity_label.pack(side=tk.LEFT)
		
		self.superball_disable_container = tk.Frame(self.superball_config_widget)
		self.superball_disable_checkbox = tk.Checkbutton(self.superball_disable_container,
													  borderwidth=0,
													  variable=projectile_props["superball_disable"][0])
		self.superball_disable_checkbox.pack(side=tk.LEFT)
		self.superball_disable_label = tk.Label(self.superball_disable_container,text=projectile_props["superball_disable"][2])
		self.superball_disable_label.pack(side=tk.LEFT)
		
		self.superball_immunity_container.pack(fill="x")
		self.superball_disable_container.pack(fill="x")
		
	def bubble_configuration(self, main_widget):
		self.bubble_config_widget = tk.LabelFrame(main_widget, text="Bubble", padx=5, pady=5)
		self.bubble_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.bubble_immunity_container = tk.Frame(self.bubble_config_widget)
		self.bubble_immunity_checkbox = tk.Checkbutton(self.bubble_immunity_container,
													  borderwidth=0,
													  variable=projectile_props["bubble_immunity"][0])
		self.bubble_immunity_checkbox.pack(side=tk.LEFT)
		self.bubble_immunity_label = tk.Label(self.bubble_immunity_container,text=projectile_props["bubble_immunity"][2])
		self.bubble_immunity_label.pack(side=tk.LEFT)
		
		self.bubble_disable_container = tk.Frame(self.bubble_config_widget)
		self.bubble_disable_checkbox = tk.Checkbutton(self.bubble_disable_container,
													  borderwidth=0,
													  variable=projectile_props["bubble_disable"][0])
		self.bubble_disable_checkbox.pack(side=tk.LEFT)
		self.bubble_disable_label = tk.Label(self.bubble_disable_container,text=projectile_props["bubble_disable"][2])
		self.bubble_disable_label.pack(side=tk.LEFT)
		
		self.bubble_immunity_container.pack(fill="x")
		self.bubble_disable_container.pack(fill="x")
		
	def elecball_configuration(self, main_widget):
		self.elecball_config_widget = tk.LabelFrame(main_widget, text="Elecball", padx=5, pady=5)
		self.elecball_config_widget.pack(fill="both", padx=3, pady=1)
		
		
		self.elecball_disable_container = tk.Frame(self.elecball_config_widget)
		self.elecball_disable_checkbox = tk.Checkbutton(self.elecball_disable_container,
														borderwidth=0,
														variable=projectile_props["elecball_disable"][0])
		self.elecball_disable_checkbox.pack(side=tk.LEFT)
		self.elecball_disable_label = tk.Label(self.elecball_disable_container,text=projectile_props["elecball_disable"][2])
		self.elecball_disable_label.pack(side=tk.LEFT)
		
		self.elecball_pierce_container = tk.Frame(self.elecball_config_widget)
		self.elecball_pierce_checkbox = tk.Checkbutton(self.elecball_pierce_container,
														borderwidth=0,
														variable=projectile_props["elecball_pierce"][0])
		self.elecball_pierce_checkbox.pack(side=tk.LEFT)
		self.elecball_pierce_label = tk.Label(self.elecball_pierce_container,text=projectile_props["elecball_pierce"][2])
		self.elecball_pierce_label.pack(side=tk.LEFT)
			
		self.elecball_paralyzed_container = tk.Frame(self.elecball_config_widget)
		self.elecball_paralyzed_checkbox = tk.Checkbutton(self.elecball_paralyzed_container,
														borderwidth=0,
														variable=projectile_props["elecball_paralyzed"][0])
		self.elecball_paralyzed_checkbox.pack(side=tk.LEFT)
		self.elecball_paralyzed_label = tk.Label(self.elecball_paralyzed_container,text=projectile_props["elecball_paralyzed"][2])
		self.elecball_paralyzed_label.pack(side=tk.LEFT)
		
		self.elecball_instakill_container = tk.Frame(self.elecball_config_widget)
		self.elecball_instakill_checkbox = tk.Checkbutton(self.elecball_instakill_container,
														borderwidth=0,
														variable=projectile_props["elecball_instakill"][0])
		self.elecball_instakill_checkbox.pack(side=tk.LEFT)
		self.elecball_instakill_label = tk.Label(self.elecball_instakill_container,text=projectile_props["elecball_instakill"][2])
		self.elecball_instakill_label.pack(side=tk.LEFT)
		
		self.elecball_fx_size_container = tk.Frame(self.elecball_config_widget)
		self.elecball_fx_size_label = tk.Label(self.elecball_fx_size_container,text=projectile_props["elecball_fx_size"][2])
		self.elecball_fx_size_label.pack(side=tk.LEFT)
		self.elecball_fx_size_combo_box = ttk.Combobox(self.elecball_fx_size_container,
														 state="readonly",
														 height=20,
														 width=30,
														 values=["16x16",
																 "32x32",
																 "16x32",
																 "16x32, shifted 16px up",
																 "32x16",
																 "48x16",
																 "64x16",
																 "80x16",
																 "64x64, shifted 8px left",
																 "64x64",
																 "16x16, shifted 8px up & left",
																 "Unused",
																 "Unused",
																 "Unused",
																 "Unused",
																 "Disappear in cloud of smoke",])
		self.elecball_fx_size_combo_box.bind("<<ComboboxSelected>>", self.selected_elec_fx_size)
		self.elecball_fx_size_combo_box.current(projectile_props["elecball_fx_size"][0].get())
		self.elecball_fx_size_combo_box.pack(side=tk.LEFT)
		
		self.elecball_note = tk.Label(self.elecball_config_widget,
									  text="NOTE: Enabling the last two options will bypass interaction with the elecballs, used for platforms",
									  wraplength=300,
									  justify=tk.LEFT)
		
		self.elecball_disable_container.pack(fill="x")
		self.elecball_pierce_container.pack(fill="x")
		self.elecball_fx_size_container.pack(fill="x")
		self.elecball_paralyzed_container.pack(fill="x")
		self.elecball_instakill_container.pack(fill="x")
		self.elecball_note.pack(side=tk.LEFT)
		
	def selected_elec_fx_size(self, event):
		projectile_props["elecball_fx_size"][0].set(self.elecball_fx_size_combo_box.current())
		

	def statue_configuration(self, main_widget):
		self.statue_config_widget = tk.LabelFrame(main_widget, text="Tanooki statue", padx=5, pady=5)
		self.statue_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.statue_disable_container = tk.Frame(self.statue_config_widget)
		self.statue_disable_checkbox = tk.Checkbutton(self.statue_disable_container,
														borderwidth=0,
														variable=projectile_props["statue_disable"][0])
		self.statue_disable_checkbox.pack(side=tk.LEFT)
		self.statue_disable_label = tk.Label(self.statue_disable_container,text=projectile_props["statue_disable"][2])
		self.statue_disable_label.pack(side=tk.LEFT)
		
		self.statue_interact_container = tk.Frame(self.statue_config_widget)
		self.statue_interact_checkbox = tk.Checkbutton(self.statue_interact_container,
														borderwidth=0,
														variable=projectile_props["statue_interact"][0])
		self.statue_interact_checkbox.pack(side=tk.LEFT)
		self.statue_interact_label = tk.Label(self.statue_interact_container,text=projectile_props["statue_interact"][2])
		self.statue_interact_label.pack(side=tk.LEFT)
		
		self.statue_disable_container.pack(fill="x")
		self.statue_interact_container.pack(fill="x")
		
	def mini_configuration(self, main_widget):
		self.mini_config_widget = tk.LabelFrame(main_widget, text="Mini Mario", padx=5, pady=5)
		self.mini_config_widget.pack(fill="both", padx=3, pady=1)
		
		self.mini_interaction_container = tk.Frame(self.mini_config_widget)
		self.mini_interaction_label = tk.Label(self.mini_interaction_container,text=projectile_props["mini_interaction"][2])
		self.mini_interaction_label.pack(side=tk.LEFT)
		self.mini_interaction_combo_box = ttk.Combobox(self.mini_interaction_container,
														 state="readonly",
														 height=20,
														 width=15,
														 values=["Disabled",
																 "Default",
																 "Check contact",
																 "Bounce off"])
		self.mini_interaction_combo_box.bind("<<ComboboxSelected>>", self.selected_mini_interaction)
		self.mini_interaction_combo_box.current(projectile_props["mini_interaction"][0].get())
		self.mini_interaction_combo_box.pack(side=tk.LEFT)
		
		self.mini_interaction_container.pack(fill="x")
		
	def selected_mini_interaction(self, event):
		projectile_props["mini_interaction"][0].set(self.mini_interaction_combo_box.current())
		
	def shell_configuration(self, main_widget):
		self.shell_config_widget = tk.LabelFrame(main_widget, text="Shell Mario", padx=5, pady=5)
		self.shell_config_widget.pack(fill="both", padx=3, pady=1, expand=True)
		
		self.shell_interaction_container = tk.Frame(self.shell_config_widget)
		self.shell_interaction_label = tk.Label(self.shell_interaction_container,text=projectile_props["shell_interaction"][2])
		self.shell_interaction_label.pack(side=tk.LEFT)
		self.shell_interaction_combo_box = ttk.Combobox(self.shell_interaction_container,
														 state="readonly",
														 height=20,
														 width=15,
														 values=["Disabled",
																 "Default",
																 "Solid",
																 "Kill, fall down",
																 "Kill, spin jump",
																 "Unused",
																 "Unused",
																 "Unused"])
		self.shell_interaction_combo_box.bind("<<ComboboxSelected>>", self.selected_shell_interaction)
		self.shell_interaction_combo_box.current(projectile_props["shell_interaction"][0].get())
		self.shell_interaction_combo_box.pack(side=tk.LEFT)
		
		self.shell_interaction_container.pack(fill="x")
		
	def selected_shell_interaction(self, event):
		projectile_props["shell_interaction"][0].set(self.shell_interaction_combo_box.current())
		
	def cat_configuration(self, main_widget):
		self.cat_config_widget = tk.LabelFrame(main_widget, text="Cat scratch", padx=5, pady=5)
		self.cat_config_widget.pack(fill="x", padx=3, pady=1)
		
		self.cat_scratch_container = tk.Frame(self.cat_config_widget)
		self.cat_scratch_checkbox = tk.Checkbutton(self.cat_scratch_container,
														borderwidth=0,
														variable=projectile_props["cat_scratch"][0])
		self.cat_scratch_checkbox.pack(side=tk.LEFT)
		self.cat_scratch_label = tk.Label(self.cat_scratch_container,text=projectile_props["cat_scratch"][2])
		self.cat_scratch_label.pack(side=tk.LEFT)
		
		self.cat_scratch_container.pack(fill="x")
		
###########################################################
		
	def update_sprite_data(self):
		global current_sprite
						
		data = settings["hammer"][current_sprite]
		projectile_props["hammer_immunity"][0].set((data>>projectile_props["hammer_immunity"][1])&1)
		projectile_props["hammer_disable"][0].set((data>>projectile_props["hammer_disable"][1])&1)
		
		data = settings["boomerang"][current_sprite]
		projectile_props["boomerang_immunity"][0].set((data>>projectile_props["boomerang_immunity"][1])&1)
		projectile_props["boomerang_disable"][0].set((data>>projectile_props["boomerang_disable"][1])&1)
		projectile_props["boomerang_retrieve"][0].set((data>>projectile_props["boomerang_retrieve"][1])&3)
		
		data = settings["iceball"][current_sprite]
		projectile_props["iceball_immunity"][0].set((data>>projectile_props["iceball_immunity"][1])&1)
		projectile_props["iceball_disable"][0].set((data>>projectile_props["iceball_disable"][1])&1)
		projectile_props["iceball_coin"][0].set((data>>projectile_props["iceball_coin"][1])&1)
		projectile_props["iceball_block_size"][0].set((data>>projectile_props["iceball_block_size"][1])&3)
		projectile_props["iceball_smoke"][0].set((data>>projectile_props["iceball_smoke"][1])&1)
		projectile_props["iceball_x_disp"][0].set((data>>projectile_props["iceball_x_disp"][1])&1)
		projectile_props["iceball_y_disp"][0].set((data>>projectile_props["iceball_y_disp"][1])&1)
		self.iceball_block_size_combo_box.current(projectile_props["iceball_block_size"][0].get())
		
		data = settings["superball"][current_sprite]
		projectile_props["superball_immunity"][0].set((data>>projectile_props["superball_immunity"][1])&1)
		projectile_props["superball_disable"][0].set((data>>projectile_props["superball_disable"][1])&1)
		
		data = settings["bubble"][current_sprite]
		projectile_props["bubble_immunity"][0].set((data>>projectile_props["bubble_immunity"][1])&1)
		projectile_props["bubble_disable"][0].set((data>>projectile_props["bubble_disable"][1])&1)
		
		data = settings["elecball"][current_sprite]
		projectile_props["elecball_paralyzed"][0].set((data>>projectile_props["elecball_paralyzed"][1])&1)
		projectile_props["elecball_disable"][0].set((data>>projectile_props["elecball_disable"][1])&1)
		projectile_props["elecball_fx_size"][0].set((data>>projectile_props["elecball_fx_size"][1])&15)
		projectile_props["elecball_instakill"][0].set((data>>projectile_props["elecball_instakill"][1])&1)
		projectile_props["elecball_pierce"][0].set((data>>projectile_props["elecball_pierce"][1])&1)
		self.elecball_fx_size_combo_box.current(projectile_props["elecball_fx_size"][0].get())
		
		data = settings["statue"][current_sprite]
		projectile_props["statue_disable"][0].set((data>>projectile_props["statue_disable"][1])&1)
		projectile_props["statue_interact"][0].set((data>>projectile_props["statue_interact"][1])&1)
		
		data = settings["mini"][current_sprite]
		projectile_props["mini_interaction"][0].set(data>>projectile_props["mini_interaction"][1]&3)
		self.mini_interaction_combo_box.current(projectile_props["mini_interaction"][0].get())
		
		data = settings["shell"][current_sprite]
		projectile_props["shell_interaction"][0].set(data>>projectile_props["shell_interaction"][1]&7)
		self.shell_interaction_combo_box.current(projectile_props["shell_interaction"][0].get())
		
		data = settings["cat"][current_sprite]
		projectile_props["cat_scratch"][0].set((data>>projectile_props["cat_scratch"][1])&1)
		
	def save_sprite_data(self):
		global current_sprite
		
		data = ((projectile_props["hammer_immunity"][0].get()<<projectile_props["hammer_immunity"][1])|
				(projectile_props["hammer_disable"][0].get()<<projectile_props["hammer_disable"][1]))
		settings["hammer"][current_sprite] = data
				
		data = ((projectile_props["boomerang_immunity"][0].get()<<projectile_props["boomerang_immunity"][1])|
				(projectile_props["boomerang_disable"][0].get()<<projectile_props["boomerang_disable"][1])|
				(projectile_props["boomerang_retrieve"][0].get()<<projectile_props["boomerang_retrieve"][1]))
		settings["boomerang"][current_sprite] = data
		
		data = ((projectile_props["iceball_immunity"][0].get()<<projectile_props["iceball_immunity"][1])|
				(projectile_props["iceball_coin"][0].get()<<projectile_props["iceball_coin"][1])|
				(projectile_props["iceball_block_size"][0].get()<<projectile_props["iceball_block_size"][1])|
				(projectile_props["iceball_disable"][0].get()<<projectile_props["iceball_disable"][1])|
				(projectile_props["iceball_smoke"][0].get()<<projectile_props["iceball_smoke"][1])|
				(projectile_props["iceball_x_disp"][0].get()<<projectile_props["iceball_x_disp"][1])|
				(projectile_props["iceball_y_disp"][0].get()<<projectile_props["iceball_y_disp"][1]))
		settings["iceball"][current_sprite] = data
		
		data = ((projectile_props["superball_immunity"][0].get()<<projectile_props["superball_immunity"][1])|
				(projectile_props["superball_disable"][0].get()<<projectile_props["superball_disable"][1]))
		settings["superball"][current_sprite] = data
		
		data = ((projectile_props["bubble_immunity"][0].get()<<projectile_props["bubble_immunity"][1])|
				(projectile_props["bubble_disable"][0].get()<<projectile_props["bubble_disable"][1]))
		settings["bubble"][current_sprite] = data
			
		data = ((projectile_props["elecball_paralyzed"][0].get()<<projectile_props["elecball_paralyzed"][1])|
				(projectile_props["elecball_disable"][0].get()<<projectile_props["elecball_disable"][1])|
				(projectile_props["elecball_fx_size"][0].get()<<projectile_props["elecball_fx_size"][1])|
				(projectile_props["elecball_instakill"][0].get()<<projectile_props["elecball_instakill"][1])|
				(projectile_props["elecball_pierce"][0].get()<<projectile_props["elecball_pierce"][1]))
		settings["elecball"][current_sprite] = data
		
		data = ((projectile_props["statue_disable"][0].get()<<projectile_props["statue_disable"][1])|
				(projectile_props["statue_interact"][0].get()<<projectile_props["statue_interact"][1]))
		settings["statue"][current_sprite] = data
		
		data = (projectile_props["mini_interaction"][0].get()<<projectile_props["mini_interaction"][1])&3
		settings["mini"][current_sprite] = data
		
		data = (projectile_props["shell_interaction"][0].get()<<projectile_props["shell_interaction"][1])&7
		settings["shell"][current_sprite] = data
		
		data = ((projectile_props["cat_scratch"][0].get()<<projectile_props["cat_scratch"][1]))
		settings["cat"][current_sprite] = data
		
if __name__ == "__main__":
	root = tk.Tk()
	
	current_sprite = 0
	
	projectile_vars = []
	for i in range(26):
		projectile_vars.append(tk.IntVar())
				
	projectile_props = {
		"hammer_immunity": [
			projectile_vars[0],
			0,
			"Immune to hammers"
		],
		"hammer_disable": [
			projectile_vars[1],
			4,
			"Disable interaction with hammers"
		],
		
		
		"boomerang_immunity": [
			projectile_vars[2],
			0,
			"Immune to boomerangs"
		],
		"boomerang_disable": [
			projectile_vars[3],
			4,
			"Disable interaction with boomerangs"
		],
		"boomerang_retrieve": [
			projectile_vars[4],
			6,
			"Can be retrieved by boomerangs"
		],
		
		
		"iceball_immunity": [
			projectile_vars[5],
			1,
			"Immune to iceballs"
		],
		"iceball_coin": [
			projectile_vars[6],
			0,
			"Ice block has a coin inside"
		],
		"iceball_block_size": [
			projectile_vars[7],
			2,
			"Ice block size: "
		],
		"iceball_disable": [
			projectile_vars[8],
			4,
			"Disable interaction with iceballs"
		],
		"iceball_smoke": [
			projectile_vars[9],
			5,
			"Disappears in cloud of smoke"
		],
		"iceball_x_disp": [
			projectile_vars[10],
			6,
			"Displace ice block 8px to the left"
		],
		"iceball_y_disp": [
			projectile_vars[11],
			7,
			"Displace ice block 16px upwards"
		],
		
		
		"superball_immunity":  [
			projectile_vars[12],
			0,
			"Immune to superballs"
		],
		"superball_disable":  [
			projectile_vars[13],
			4,
			"Disable interaction with superballs"
		],
		
		
		"bubble_immunity":  [
			projectile_vars[14],
			2,
			"Immune to bubbles"
		],
		"bubble_disable":  [
			projectile_vars[15],
			4,
			"Disable interaction with bubbles"
		],
		
		"elecball_pierce":  [
			projectile_vars[16],
			5,
			"Disappear elecball on contact"
		],
		"elecball_disable":  [
			projectile_vars[17],
			4,
			"Disable interaction with elecballs"
		],
		"elecball_paralyzed":  [
			projectile_vars[18],
			6,
			"Can't be paralyzed by elecballs"
		],
		"elecball_instakill":  [
			projectile_vars[19],
			7,
			"Can be defeated when electrified"
		],
		"elecball_fx_size":  [
			projectile_vars[20],
			0,
			"Electricity FX size: "
		],
		
		"statue_disable": [
			projectile_vars[21],
			3,
			"Can't be killed by Tanooki's statue"
		],
		"statue_interact": [
			projectile_vars[22],
			5,
			"Run default interaction with Tanooki's statue"
		],
		
		"mini_interaction": [
			projectile_vars[23],
			0,
			"Mini Mario behavior: "
		],
		
		"shell_interaction": [
			projectile_vars[24],
			0,
			"Shell Mario behavior: "
		],
		
		"cat_scratch": [
			projectile_vars[25],
			0,
			"Can't be killed by Cat Mario's scratch"
		]
		
	}	
	
	sprite_names = []
	hammer_settings = []
	boomerang_settings = []
	iceball_settings = []
	superball_settings = []
	bubble_settings = []
	elecball_settings = []
	statue_settings = []
	mini_settings = []
	shell_settings = []
	cat_settings = []
	
	settings = {
		"hammer": [],
		"boomerang": [],
		"iceball": [],
		"superball": [],
		"bubble": [],
		"elecball": [],
		"statue": [],
		"mini": [],
		"shell": [],
		"cat": []
	}
	
	for i in range(512):
		sprite_names.append("")
		settings["hammer"].append(0)
		settings["boomerang"].append(0)
		settings["iceball"].append(0)
		settings["superball"].append(0)
		settings["bubble"].append(0)
		settings["elecball"].append(0)
		settings["statue"].append(0)
		settings["mini"].append(0)
		settings["shell"].append(0)
		settings["cat"].append(0)
								
	toolbar = Toolbar(root)
	mainframe = MainFrame(root)
	root.title("Custom Powerup Sprite Config")
	root.geometry("600x515")
	root.resizable(False, False)
	root.iconbitmap('powerup_sprite_config.ico')
	root.mainloop()
	
	
	
	