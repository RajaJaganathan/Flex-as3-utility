/*
 * Copyright (c) 2010, Andrea Bresolin (http://www.devahead.com)
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer;
 * - redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - neither the name of www.devahead.com nor the names of its contributors may
 *   be used to endorse or promote products derived from this software without
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS”
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

package com.devahead.modules
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.controls.Alert;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	public class ModulesManager extends EventDispatcher
	{
		protected static var _instance: ModulesManager = null;
		
		public static function getInstance(): ModulesManager
		{
			if (_instance == null)
			{
				_instance = new ModulesManager();
				
				_instance.loadAssetsModule();
			}
			
			return _instance;
		}

		protected var _assets: IAssetsModule = null;

		[Bindable("assetsModuleChanged")]
		public function get assets(): IAssetsModule
		{
			return _assets;
		}

		protected var _assetsModuleLoader: ModuleLoader = null;
		
		protected function loadAssetsModule(): void
		{
			if (_assetsModuleLoader == null)
			{
				_assetsModuleLoader = new ModuleLoader();
				_assetsModuleLoader.addEventListener(ModuleEvent.READY, onAssetsModuleReady);
				_assetsModuleLoader.addEventListener(ModuleEvent.ERROR, onAssetsModuleError);
				_assetsModuleLoader.loadModule("com/devahead/modules/AssetsModule.swf");
			}
		}
		
		protected function onAssetsModuleReady(event: ModuleEvent): void
		{
			_assets = (_assetsModuleLoader.child as IAssetsModule);
			
			dispatchEvent(new Event("assetsModuleChanged"));
		}

		protected function onAssetsModuleError(event: ModuleEvent): void
		{
			Alert.show("Error while loading AssetsModule.\n\n" + event.errorText, "Error");
		}
	}
}