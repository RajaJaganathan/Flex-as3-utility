package com.abc.images
{
	public final class ImageFactory
	{
		public function ImageFactory()
		{
		}

		[Embed (source="/assets/imageSs/close.gif" )]
		public static const CLOSE_IMG:Class;

		[Embed(source="library.swf", symbol="star")]
		private var Star:Class;

	}
}

