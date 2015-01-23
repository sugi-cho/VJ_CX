using UnityEngine;
using System.Collections;
 
public class DetectLeaks : MonoBehaviour 
{
	bool debug;
	
	void Update(){
		if(Input.GetKeyDown(KeyCode.D))
			debug = !debug;
	}
	
	void OnGUI () {
		if(!debug)
			return;
		
		GUILayout.Label("All " + FindObjectsOfType(typeof(UnityEngine.Object)).Length);
		GUILayout.Label("Textures " + FindObjectsOfType(typeof(Texture)).Length);
		GUILayout.Label("RenderTextures " + FindObjectsOfType(typeof(RenderTexture)).Length);
		GUILayout.Label("AudioClips " + FindObjectsOfType(typeof(AudioClip)).Length);
		GUILayout.Label("Meshes " + FindObjectsOfType(typeof(Mesh)).Length);
		GUILayout.Label("Materials " + FindObjectsOfType(typeof(Material)).Length);
		GUILayout.Label("GameObjects " + FindObjectsOfType(typeof(GameObject)).Length);
		GUILayout.Label("Components " + FindObjectsOfType(typeof(Component)).Length);
	}
}