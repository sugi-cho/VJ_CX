using UnityEngine;
using System.Net;
using System.Net.Sockets;
using System.Collections.Generic;

public class OscServer : MonoBehaviour
{
	public int listenPort = 6666;
	public string OSCPath = "/point";
	public int maxSend = 10;
	public GameObject target;

	UdpClient udpClient;
	IPEndPoint endPoint;
	Osc.Parser osc = new Osc.Parser ();
	
	void Start ()
	{
		if (Application.isWebPlayer) {
			Destroy (this);
			return;
		}
		endPoint = new IPEndPoint (IPAddress.Any, listenPort);
		udpClient = new UdpClient (endPoint);
	}
	
	void Update ()
	{
		
		while (udpClient.Available > 0) {
			osc.FeedData (udpClient.Receive (ref endPoint));
		}
		
		int count = 0;

		while (osc.MessageCount > 0) {
			var msg = osc.PopMessage ();
			
			if (msg.path.StartsWith (OSCPath) && count < maxSend) {
				float
				x = (float)msg.data [0],
				y = (float)msg.data [1],
				w = (float)msg.data [2],
				h = (float)msg.data [3];
				
				Vector2 point = Random.insideUnitCircle;
				point.x *= w / 2f;
				point.y *= h / 2f;
				point.x += x + w / 2f;
				point.y += y + h / 2f;

				if (target != null)
					target.SendMessage ("OnOSC", point, SendMessageOptions.DontRequireReceiver);
				count++;

			}
		}
	}
}