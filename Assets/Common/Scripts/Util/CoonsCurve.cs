using UnityEngine;
using System.Collections;

public class CoonsCurve {
	private Vector3 a, b, c, d;
	
	public CoonsCurve(Vector3 p0, Vector3 p1, Vector3 v0, Vector3 v1) {
		this.a =  2 * p0 - 2 * p1 +     v0 + v1;
		this.b = -3 * p0 + 3 * p1 - 2 * v0 - v1;
		this.c = v0;
		this.d = p0;
	}
	
	public Vector3 Interpolate(float t) {
		var t2 = t * t;
		var t3 = t2 * t;
		return a * t3 + b * t2 + c * t + d;
	}
}
